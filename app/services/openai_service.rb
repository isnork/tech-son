class OpenaiService
  def initialize
    @client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])
  end

  def analyze_scam_check(scam_check)
    prompt = build_prompt(scam_check)
    
    begin
      response = @client.chat(
        parameters: {
          model: "gpt-4o-mini",
          messages: [
            {
              role: "system",
              content: "You are a security specialist that is an expert in phishing, abuse and online scams. You are offering an online Service that a user can go to, describe the problem they are having and ask if we believe they may be being scammed.\n\nThe user will ask a question, upload a screenshot or other image, provide a URL to an external website or an email address for who they think is scamming them. As the security researcher, you will analyze the content and provide an opinion with an accuracy rating. In the result state the reasons why you came to this decision.\n\nIMPORTANT: You cannot see uploaded images or screenshots. You can only analyze the text-based information provided (description, URL, email). Do not ask the user to provide a screenshot.\n\nProvide your analysis in the required format. Always give your best assessment based on the available information. If your confidence is low, state that in the REASONS and explain what information would improve the analysis.\n\nIf you need more information to provide a more confident analysis, you MUST ask for it. When you do, provide a list of specific, actionable questions or examples of details the user can provide. Enclose this list in [SUGGESTIONS] tags, like this: [SUGGESTIONS]...list of questions...[/SUGGESTIONS]"
            },
            {
              role: "user",
              content: prompt
            }
          ],
          max_tokens: 1000,
          temperature: 0.3
        }
      )
      
      response.dig("choices", 0, "message", "content")
    rescue => e
      Rails.logger.error "OpenAI API Error: #{e.message}"
      "I'm sorry, but I'm unable to analyze this right now due to a technical issue. Please try again later."
    end
  end

  private

  def build_prompt(scam_check)
    prompt_parts = []
    
    prompt_parts << "Please analyze the following suspicious activity and determine if the user is being scammed:"
    prompt_parts << ""
    prompt_parts << "USER'S QUESTION/DESCRIPTION: #{scam_check.description}"
    
    if scam_check.email.present?
      prompt_parts << "SUSPICIOUS EMAIL ADDRESS: #{scam_check.email}"
    end
    
    if scam_check.url.present?
      prompt_parts << "SUSPICIOUS URL: #{scam_check.url}"
    end
    
    if scam_check.screenshot.attached?
      prompt_parts << "SCREENSHOT: A screenshot has been uploaded (Note: I cannot see the actual image content, but I can analyze based on the description and other provided information)"
    end
    
    prompt_parts << ""
    prompt_parts << "Please provide your analysis in the following format:"
    prompt_parts << "OPINION: [Scam/Likely Scam/Possible Scam/Legitimate/Unable to Determine]"
    prompt_parts << "ACCURACY RATING: [High/Medium/Low]"
    prompt_parts << "REASONS: [Detailed explanation of why you came to this decision based on the available information]"
    prompt_parts << ""
    prompt_parts << "IMPORTANT: Always provide your best assessment based on the available information. Also ask the user if they can provide additional details that would make your analysis more accurate. Only use 'Unable to Determine' if you have zero information to analyze."
    
    prompt_parts.join("\n")
  end
end 