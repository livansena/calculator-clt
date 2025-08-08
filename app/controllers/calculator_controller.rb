class CalculatorController < ApplicationController
  def index
  end

  def calculate
    gross_salary = params[:gross_salary].to_f
    dependents = params[:dependents].to_i
    other_deductions = params[:transportation_voucher].to_f

    inss = calculate_inss(gross_salary)
    irrf_base = gross_salary - inss - (dependents * 189.59)
    irrf = calculate_irrf(irrf_base)
    
    net_salary = gross_salary - inss - irrf - other_deductions

    render json: {
      gross_salary: format_currency(gross_salary),
      inss: format_currency(inss),
      irrf: format_currency(irrf),
      net_salary: format_currency(net_salary)
    }
  end

  private

  def calculate_inss(salary)
    # INSS table 2025 (fictional values, update with correct ones)
    if salary <= 1412.0
      salary * 0.075
    elsif salary <= 2666.68
      (1412.0 * 0.075) + ((salary - 1412.0) * 0.09)
    elsif salary <= 4000.03
      (1412.0 * 0.075) + ((2666.68 - 1412.0) * 0.09) + ((salary - 2666.68) * 0.12)
    else
      # INSS ceiling (fictional value, update with correct one)
      500.0
    end
  end

  def calculate_irrf(base)
    # IRRF table 2025 (fictional values, update with correct ones)
    if base <= 2259.2
      0.0
    elsif base <= 2826.65
      (base * 0.075) - 169.44
    elsif base <= 3751.05
      (base * 0.15) - 381.44
    else
      # Other ranges
      (base * 0.275) - 869.36
    end
  end

  def format_currency(value)
    "R$ #{'%.2f' % value}"
  end
end
