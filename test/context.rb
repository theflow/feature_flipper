class Context
  attr_reader :current_user_betas

  def initialize(*betas)
    @current_user_betas = betas
  end
end
