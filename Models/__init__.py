from google import genai


client = genai.Client()


interaction = client.interactions.create(

    agent="antigravity-preview-05-2026",

    input="Research the top 10 AI stories today and create a PDF briefing with summaries",

    environment="remote",  # Remote Linux environment hosted by Google

)
