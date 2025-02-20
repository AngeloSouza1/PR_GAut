class Api::V1::Webhook::Xxx::PaymentsController < ApiController
  skip_before_action :authenticate_request

  def update
    Whitemex::Webhook::Payment::UpdatedJob.send((Rails.env.to_sym == :development ? :perform_now : :perform_later), payment_params)
    render json: 'ok'
  end

  private

  def payment_params
    params.permit!.to_h.merge({
      classepay: {
        kind_gateway: 'xxx'
      }
    })
  end
end
