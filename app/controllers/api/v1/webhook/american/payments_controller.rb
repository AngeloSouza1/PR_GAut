module Api::V1::Webhook::American
  class PaymentsController < ApiController
    skip_before_action :authenticate_request

    def update
      Shield::Webhook::Payment::UpdatedJob.send((Rails.env.to_sym == :development ? :perform_now : :perform_later), payment_params)
      render json: 'ok'
    end

    private

    def payment_params
      params.permit!.to_h.merge({
        classepay: {
          kind_gateway: 'american'
        }
      })
    end
  end
end
