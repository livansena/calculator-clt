require 'rails_helper'

RSpec.describe CalculatorController, type: :controller do
  subject { described_class.new }

  describe '#calculate_inss' do
    context 'when gross salary is in the first range (up to R$ 1,412.00)' do
      it 'calculates INSS with a 7.5% rate' do
        salary = 1000.00
        expected_inss = salary * 0.075
        expect(subject.send(:calculate_inss, salary)).to eq(expected_inss)
      end
    end

    context 'when gross salary is in the second range (from R$ 1,412.01 to R$ 2,666.68)' do
      it 'calculates INSS with the progressive rate' do
        salary = 2000.00
        expected_inss = (1412.0 * 0.075) + ((salary - 1412.0) * 0.09)
        expect(subject.send(:calculate_inss, salary)).to eq(expected_inss)
      end
    end

    context 'when gross salary is in the third range (from R$ 2,666.69 to R$ 4,000.03)' do
      it 'calculates INSS with the progressive rate' do
        salary = 3500.00
        expected_inss = (1412.0 * 0.075) + ((2666.68 - 1412.0) * 0.09) + ((salary - 2666.68) * 0.12)
        expect(subject.send(:calculate_inss, salary)).to eq(expected_inss)
      end
    end

    context 'when gross salary is above the ceiling (above R$ 4,000.03)' do
      it 'applies the INSS ceiling value' do
        salary = 5000.00
        expected_inss = 500.00 # Ceiling value in your code
        expect(subject.send(:calculate_inss, salary)).to eq(expected_inss)
      end
    end
  end

  describe '#calculate_irrf' do
    context 'when the tax base is up to R$ 2,259.20' do
      it 'returns zero IRRF' do
        base = 1500.00
        expected_irrf = 0.0
        expect(subject.send(:calculate_irrf, base)).to eq(expected_irrf)
      end
    end

    context 'when the tax base is in the second range (from R$ 2,259.21 to R$ 2,826.65)' do
      it 'calculates IRRF with a 7.5% rate' do
        base = 2500.00
        expected_irrf = (base * 0.075) - 169.44
        expect(subject.send(:calculate_irrf, base)).to eq(expected_irrf)
      end
    end

    context 'when the tax base is in the third range (from R$ 2,826.66 to R$ 3,751.05)' do
      it 'calculates IRRF with a 15% rate' do
        base = 3000.00
        expected_irrf = (base * 0.15) - 381.44
        expect(subject.send(:calculate_irrf, base)).to eq(expected_irrf)
      end
    end

    context 'when the tax base is in the fourth range (above R$ 3,751.05)' do
      it 'calculates IRRF with a 27.5% rate' do
        base = 4500.00
        expected_irrf = (base * 0.275) - 869.36
        expect(subject.send(:calculate_irrf, base)).to eq(expected_irrf)
      end
    end
  end
end
