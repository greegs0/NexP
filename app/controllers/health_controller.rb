class HealthController < ApplicationController
  # Pas besoin d'authentification pour le health check
  skip_before_action :verify_authenticity_token

  def show
    # Vérifier les services critiques
    checks = {
      status: 'ok',
      timestamp: Time.current.iso8601,
      services: {
        database: check_database,
        redis: check_redis,
        storage: check_storage
      }
    }

    # Si un service est down, retourner 503
    if checks[:services].values.any? { |service| service[:status] == 'down' }
      render json: checks, status: :service_unavailable
    else
      render json: checks, status: :ok
    end
  rescue => e
    render json: {
      status: 'error',
      error: e.message,
      timestamp: Time.current.iso8601
    }, status: :service_unavailable
  end

  private

  def check_database
    ActiveRecord::Base.connection.execute('SELECT 1')
    { status: 'up', latency_ms: measure_latency { ActiveRecord::Base.connection.execute('SELECT 1') } }
  rescue => e
    { status: 'down', error: e.message }
  end

  def check_redis
    Redis.new(url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/1')).ping
    { status: 'up', latency_ms: measure_latency { Redis.new(url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/1')).ping } }
  rescue => e
    { status: 'down', error: e.message }
  end

  def check_storage
    # Vérifier que Active Storage est accessible
    ActiveStorage::Blob.limit(1).count
    { status: 'up' }
  rescue => e
    { status: 'down', error: e.message }
  end

  def measure_latency
    start = Time.current
    yield
    ((Time.current - start) * 1000).round(2)
  end
end
