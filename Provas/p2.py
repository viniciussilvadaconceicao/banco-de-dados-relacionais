import tkinter as tk
from tkinter import messagebox
import psycopg2

# Conectar ao banco PostgreSQL (você deve preencher os dados corretos)
conn = psycopg2.connect(
    dbname="postgres",
    user="postgres",
    password="pgadmin",
    host="localhost"
    )
cur = conn.cursor()

# Função de cadastro
def cadastrar():
    try:
        nome_medico = entry_medico.get()
        especialidade = entry_esp.get()
        nome_paciente = entry_paciente.get()
        data_nascimento = entry_nascimento.get()
        data_consulta = entry_data.get()
        valor = float(entry_valor.get())

        cur.execute("INSERT INTO medico(nome_medico,especialidade) VALUES (%s, %s) RETURNING id_medico",
        (nome_medico, especialidade))
        id_medico = cur.fetchone()[0]

        cur.execute("INSERT INTO paciente(nome_paciente,data_nascimento) VALUES (%s, %s) RETURNING id_paciente",
        (nome_paciente, data_nascimento))
        id_paciente = cur.fetchone()[0]

        cur.execute("INSERT INTO consulta(id_medico,id_paciente,data_consulta,valor) VALUES (%s, %s, %s, %s)",
        (id_medico, id_paciente, data_consulta, valor))
        conn.commit()
        messagebox.showinfo("Sucesso", "Dados cadastrados com sucesso!")
    except Exception as e:
        conn.rollback()
        messagebox.showerror("Erro", str(e))

# Função para exibir a view consultas realizadas

def ver_consultas():
    try:
        cur.execute("SELECT * FROM consultas_realizadas")
        dados = cur.fetchall()
        texto = "\n".join([f"{row[0]} - {row[1]} - {row[2]} - R${row[3]:.2f}" for row in dados])
        messagebox.showinfo("consultasrealizadas", texto)

    except Exception as e:
        messagebox.showerror("Erro", str(e))

# Interface Gráfica
root = tk.Tk()
root.title("Cadastro de Consultas Médicas")
entry_medico = tk.Entry(root); entry_medico.pack(); entry_medico.insert(0, "Nome do Médico:")
entry_esp = tk.Entry(root); entry_esp.pack(); entry_esp.insert(0, "Especialidade:")
entry_paciente = tk.Entry(root); entry_paciente.pack(); entry_paciente.insert(0, "Nome do Paciente:")
entry_nascimento = tk.Entry(root); entry_nascimento.pack(); entry_nascimento.insert(0, "Data deNascimento:")
entry_data = tk.Entry(root); entry_data.pack(); entry_data.insert(0, "Data da Consulta:")
entry_valor = tk.Entry(root); entry_valor.pack(); entry_valor.insert(0, "Valor da Consulta:")
btn_cadastrar = tk.Button(root, text="Cadastrar", command=cadastrar)
btn_cadastrar.pack()
btn_ver = tk.Button(root, text="Ver Consultas", command=ver_consultas)
btn_ver.pack()
root.mainloop()