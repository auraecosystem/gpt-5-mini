export interface Env {
  AI: Ai;
}


export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const res = await fetch("https://127.0.0.1:8000");
    const blob = await res.arrayBuffer();
    const input = {
      image: [...new Uint8Array(blob)],
      prompt: "Generate a caption for this image",
      max_tokens: 512,
    };
    const response = await env.AI.run(
      "@modelstore/lmlm/gpt-5-mini",
      input
      );
    return new Response(JSON.stringify(response));
  },
} satisfies ExportedHandler<Env>
