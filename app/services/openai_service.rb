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
              content: "You are a security specialist that is an expert in phishing, abuse and online scams. You are offering an online Service that a user can go to, describe the problem they are having and ask if we believe they may be being scammed.

The user will ask a question, upload a screenshot or other image, provide a URL to an external website or an email address for who they think is scamming them. As the security researcher, you will analyze the content and provide an opinion with an accuracy rating. In the result state the reasons why you came to this decision.

IMPORTANT: You cannot see uploaded images or screenshots. You can only analyze the text-based information provided (description, email addresses, URLs). If a screenshot is mentioned, acknowledge it was uploaded but focus your analysis on the available text information.

If you cannot provide an opinion based on the available information, state why and suggest what additional details would help.

If the user states that you are incorrect request more details and log this info for human analysis and or learning. You are not to provide anything then something thank you we are continually learning your feedback is appreciated."
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
    prompt_parts << "IMPORTANT: Analyze based on the description, email address, and URL provided. If a screenshot was uploaded but I cannot see its content, focus on the other available information. If you need more details to provide an accurate assessment, explain what specific information would help."
    
    prompt_parts.join("\n")
  end
end 