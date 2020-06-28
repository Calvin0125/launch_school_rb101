def prompt(message)
  puts "=> #{message}"
end

prompt("Welcome to the loan calculator!")

loop do
  prompt("This program will determine the monthly payment of your loan.")

  loan_amount = ''
  loop do
    prompt("What is your loan amount?")
    loan_amount = gets.chomp
    loan_amount.gsub!(/,/, '')
    if loan_amount =~ /\A[0-9]+\z/
      loan_amount = loan_amount.to_f
      break
    else
      prompt("That doesn't look like a valid number.")
    end
  end

  apr = ''
  loop do
    prompt("What is your APR (as an integer)?")
    apr = gets.chomp
    if apr =~ /\A[0-9]{1,2}\z/
      apr = (apr.to_f / 100.0)
      break
    else
      prompt("That doesn't look like a valid APR.")
    end
  end

  duration_years = ''
  loop do
    prompt("What is the duration of your loan in years?")
    duration_years = gets.chomp
    if duration_years =~ /\A[0-9]+\z/
      duration_years = duration_years.to_f
      break
    else
      prompt("That doesn't look like a valid duration.")
    end
  end

  monthly_interest_rate = apr / 12.0
  duration_months = duration_years * 12.0

  monthly_payment = (loan_amount * (monthly_interest_rate / \
                    (1 - (1 + monthly_interest_rate)**-duration_months)))\
                    .round(2)

  prompt("Your monthly payment is #{monthly_payment}.")

  prompt("Would you like to calculate another loan payment? ('Y' for yes)")
  answer = gets.chomp.downcase
  break unless answer == 'y'
end
