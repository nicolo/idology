module IDology
  class Subject
    include HTTParty
    base_uri 'https://web.idologylive.com/api'
    # pem File.read(File.dirname(__FILE__) + '/certs/cacert.pem')
    parser lambda{|r, format| IDology::Response.parse(r.to_s)}

    SearchAttributes = [:firstName, :lastName, :address, :city, :state, :zip, :ssnLast4, :ssn, :dobMonth, :dobYear]
    CommonAttributes = [:idNumber, :uid]

    Paths = {
      :search => '/idiq.svc',
      :answers => '/idliveq-answers.svc',
      :challenge_questions => '/idliveq-challenge.svc',
      :challenge_answers => '/idliveq-challenge-answers.svc'
    }

    attr_accessor *SearchAttributes
    attr_accessor *CommonAttributes
    attr_accessor :response, :qualifiers, :verification_questions, :eligible_for_verification, :verified, :challenge, :challenge_questions, :questions

    def initialize(data = {})
      self.verified = self.challenge = self.eligible_for_verification = false
      self.qualifiers = ""

      data.each {|key, value| self.send "#{key}=", value }
    end

    def idNumber
      @idNumber.blank? && response ? response.id : @idNumber
    end

    def eligible_for_verification?
      response.eligible_for_verification?
    end

    def identified?
      response.identified?
    end

    def verified?
      response.verified?
    end

    def questions
      @questions ||= (response && !response.questions.empty?) ? response.questions : []
    end

    def qualifiers
      response.qualifiers
    end

    def locate
      post(:search, SearchAttributes)
      identified? ? response : false
    end

    def submit_answers
      post(:answers, [], answer_params)
    end

    def get_challenge_questions
      # get_challenge_questions is an IDology ExpectID Challenge API call - given a valid idNumber from an ExpectID IQ question
      # and response process, will return questions to further verify the subject
      post(:challenge_questions)
    end

    def submit_challenge_answers
      post(:challenge_answers, [], answer_params)
    end

  private

    def post(url, attributes = [], data = {})
      raise IDology::Error, "IDology username is not set." if IDology[:username].blank?
      raise IDology::Error, "IDology password is not set." if IDology[:password].blank?

      data.merge!(:username => IDology[:username],
        :password => IDology[:password])

      (attributes | CommonAttributes).each do |key|
        data[key] = self.send(key) unless self.send(key).blank?
      end

      if url != :search && data[:idNumber].blank?
        raise IDology::Error, "idNumber can't be blank."
      end

      self.response = Subject.post(Paths[url], :body => data)

      raise IDology::Error, self.response.errors if self.response.errors?

      self.response
    #rescue Timeout::Error, Net::HTTPError => e
    #  raise IDology::Error, e.message
    end

    def answer_params
      answers = {}
      questions.each_with_index do |question, index|
        answers["question#{index + 1}Type"] = question.type
        answers["question#{index + 1}Answer"] = question.chosen_answer
      end
      answers
    end
  end
end
