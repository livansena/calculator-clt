document.addEventListener('DOMContentLoaded', () => {
  const form = document.getElementById('calculator-form');
  const resultsDiv = document.getElementById('results');
  const inssResultSpan = document.getElementById('inss-result');
  const irrfResultSpan = document.getElementById('irrf-result');
  const netSalaryResultSpan = document.getElementById('net-salary-result');

  form.addEventListener('submit', async (event) => {
    event.preventDefault();

    const grossSalary = document.getElementById('gross-salary').value;
    const dependents = document.getElementById('dependents').value;
    const transportationVoucher = document.getElementById('transportation-voucher').value;

    const data = {
      gross_salary: grossSalary,
      dependents: dependents,
      other_deductions: transportationVoucher
    };

    try {
      const response = await fetch('/calculate', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify(data)
      });

      const result = await response.json();

      if (response.ok) {
        inssResultSpan.textContent = result.inss;
        irrfResultSpan.textContent = result.irrf;
        netSalaryResultSpan.textContent = result.net_salary;
        resultsDiv.style.display = 'block';
      } else {
        alert('An error occurred while calculating. Please try again.');
      }
    } catch (error) {
      console.error('Error:', error);
      alert('Could not connect to the server. Please check your connection.');
    }
  });
});
