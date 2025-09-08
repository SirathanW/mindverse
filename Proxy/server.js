const express = require("express");
const cors = require("cors");
const dotenv = require("dotenv");

dotenv.config();
const app = express();
app.use(cors());
app.use(express.json());

const PORT = process.env.PORT || 8080;
const HF_TOKEN = process.env.HF_TOKEN;
const HF_MODEL = process.env.HF_MODEL || "Claude 3.5 Haiku";

app.get("/health", (req, res) => res.json({ status: "ok" }));

app.post("/chat", async (req, res) => {
  try {
    if (!HF_TOKEN) {
      return res.status(500).json({ error: "Missing HF_TOKEN in .env" });
    }
    const userInput = req.body?.input ?? "Hello";
    const r = await fetch(`https://api-inference.huggingface.co/models/${HF_MODEL}`, {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${HF_TOKEN}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ inputs: userInput })
    });

    const data = await r.json();
    const reply =
      data?.[0]?.generated_text ??
      data?.generated_text ??
      data?.conversation?.generated_responses?.[0] ??
      JSON.stringify(data);

    res.json({ reply });
  } catch (err) {
    res.status(500).json({ error: err?.message ?? String(err) });
  }
});

app.listen(PORT, () => {
  console.log(`✅ Proxy server running on http://localhost:${PORT}`);
});
