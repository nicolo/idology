module IDology
  class Response
    include HappyMapper
    
    element :id, Integer, :tag => 'id-number'
    element :failed, String
    element :error, String
    element :iq_challenge_summary_result, String, :tag => 'iq-challenge-summary-result'
    element :iq_summary_result, String, :tag => 'iq-summary-result'
    element :iq_indicated, IDology::Boolean, :tag => 'idliveq-indicated', :parser => :parse
    element :eligible_for_questions, IDology::Boolean, :tag => 'eligible-for-questions', :parser => :parse
    element :id_note_score, Integer, :tag => 'idnotescore'
    
    has_one :result, IDology::Result
    has_one :summary_result, IDology::SummaryResult
    has_one :iq_result, IDology::IQResult
    has_one :iq_challenge_result, IDology::IQChallengeResult
    has_one :iq_error, IDology::IQError
    has_many :qualifiers, IDology::Qualifier
    has_many :questions, IDology::Question
    has_many :velocity_results, IDology::VelocityResult
    
    # A helper method as this can be an element or in the iq_error
    def ineligible_for_questions?
      eligible_for_questions == false || (iq_error && %w(id.not.eligible.for.questions result.questions.no.data).include?(iq_error.key))
    end
    
    def eligible_for_verification?
      !error? && result && result.match? && (!ineligible_for_questions? || questions)
    end
    
    def verified?
      !error? && [iq_result, iq_challenge_result].compact.all?{|r| r.verified?}
    end
    
    def identified?
      !error? && (IDology[:summary_results] ? summary_result.success? : result.match?)
    end

    def matched?
      !error? && result.match?
    end
    
    def timeout?
      [iq_result, iq_challenge_result].compact.map(&:key).include?('result.timeout')
    end
    
    def errors?
      timeout? || ![failed, error].compact.empty?
    end
    alias_method :error?, :errors?
    
    def errors
      [failed, error].compact.map{|e| e.to_s}.join(',')
    end
  end
end
