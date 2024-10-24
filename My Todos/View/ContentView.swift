//
//  ContentView.swift
//  My Todos
//
//  Created by Ana Carolina B. de Magalhães on 13/10/24.
//

import SwiftUI

struct ContentView: View {
    @State private var taskInput: String = ""
    @State private var tasks: [Task] = []
    @State private var taskToEdit: Task? = nil
    @State private var isEditing: Bool = false

    var body: some View {
        VStack (alignment: .leading, spacing: 10) {
            Text("My To-Dos")
                .font(.custom("Avenir-Black", size: 34))
                .padding(.bottom, 2)
            
            inputView
            
            VStack (alignment: .center) {
                if tasks.isEmpty {
                    Text("No tasks yet. Start adding some!")
                        .font(.custom("Avenir-Black", size: 18))
                        .padding()
                }
                
                NavigationView {
                    taskListView
                }
            }
        }
        .padding()
    }
    
    private var inputView: some View {
        HStack {
            TextField("Write your todos", text: $taskInput, onCommit: {
                if isEditing {
                    saveEditedTask()
                } else {
                    addTodo()
                }
            })
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .background(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black, lineWidth: 2)
            )
            .cornerRadius(8)
            .padding(.vertical, 10)

            Button(action: {
                if isEditing {
                    saveEditedTask()
                } else {
                    addTodo()
                }
            }) {
                Text(isEditing ? "Save" : "Add")
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 2)
                    )
                    .foregroundColor(Color.black)
                    .cornerRadius(8)
            }
        }
    }
    
    private var taskListView: some View {
        List {
            ForEach(tasks) { task in
                HStack(alignment: .center) {
                    completionButton(for: task)
                    
                    VStack(alignment: .leading) {
                        Text(task.title)
                            .font(.title3)
                        
                        Text(formatDate(task.date))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        removeTask(task: task)
                    } label: {
                        Label("Apagar", systemImage: "trash")
                    }
                    
                    Button {
                        startEditingTask(task: task)
                    } label: {
                        Label("Editar", systemImage: "pencil")
                    }.tint(.blue)
                }
                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                    Button {
                        toggleCompleted(task: task)
                    } label: {
                        Label("Concluir", systemImage: "checkmark")
                    }.tint(.green)
                }
                .strikethrough(task.isCompleted)
            }
        }
        .listStyle(.inset)
    }

    private func completionButton(for task: Task) -> some View {
        Button(action: {
            toggleCompleted(task: task)
        }) {
            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "checkmark.circle")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(task.isCompleted ? .green : .primary)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    func addTodo() {
        guard !taskInput.isEmpty else { return }
        let newTask = Task(title: taskInput.trimmingCharacters(in: .whitespacesAndNewlines),
                           date: Date(),
                           isCompleted: false)
        tasks.insert(newTask, at: 0)
        taskInput = ""
    }
    
    func removeTask(task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks.remove(at: index)
        }
    }
    
    func toggleCompleted(task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
    }
    
    func startEditingTask(task: Task) {
        taskToEdit = task
        taskInput = task.title
        isEditing = true
    }
    
    func saveEditedTask() {
        if let taskToEdit = taskToEdit,
           let index = tasks.firstIndex(where: { $0.id == taskToEdit.id }) {
            tasks[index].title = taskInput.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        resetInput()
    }

    func resetInput() {
        taskInput = ""
        isEditing = false
        taskToEdit = nil
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    ContentView()
}
