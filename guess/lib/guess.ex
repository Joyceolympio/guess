defmodule Guess do
  use Application

  def start(_,_) do
    run()
    {:ok, self()}
  end

  def run() do
    IO.puts("O jogo vai começar!")

    IO.gets("Escolha o nível de dificuldade (1, 2 ou 3): ")
    |> parse_input()
    |> pickup_number()
    |> play()
  end

  def pickup_number(level) do
    level
    |> get_range()
    |> Enum.random()
  end

  def play(picked_num) do
    IO.gets("Já tenho o número. Agora você precisa adivinha-lo: ")
    |> parse_input()
    |> guess(picked_num, 1)
  end

  def guess(user_guess, picked_num, count) when user_guess > picked_num do
    IO.gets("Número alto, dê um novo palpite: ")
    |> parse_input()
    |> guess(picked_num, count + 1)
  end
  
  def guess(user_guess, picked_num, count) when user_guess < picked_num do
    IO.gets("Número baixo, dê um novo palpite: ")
    |> parse_input()
    |> guess(picked_num, count + 1)
  end

  def guess(_user_guess, _picked_num, count) do
    IO.puts("Você acertou em #{count} palpites")
    score(count)
  end

  def score(guesses) when guesses > 6 do
    IO.puts("Muitas tentativas!")
  end

  def score(guesses) do
    {_, msg} =  %{1..1 => "Ual, você deve ler mentes!",
      2..4 => "Boa!!",
      3..6 => "Da pra melhorar hein"
    }
    |> Enum.find(fn {range, _} -> 
      Enum.member?(range, guesses)
    end)
    IO.puts(msg)

  end

  def parse_input(:error) do
      IO.puts("Nível inválido!!")
      run()
  end

  def parse_input({num, _}), do: num 

  def parse_input(data) do 
    data
    |> Integer.parse()
    |> parse_input()
  end

  def get_range(level) do 
    case level do 
      1 -> 1..10
      2 -> 1..100
      3 -> 1..1000
      _ -> IO.puts("Level inválido!!!")
        run()
    end
  end
end
