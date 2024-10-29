//
//  CreateView.swift
//  SwiftUIFundamentalProject
//
//  Created by Panachai Sulsaksakul on 9/30/24.
//

import SwiftUI

struct CreateView: View {
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Field?
    @StateObject private var vm = CreateViewModel()
    let successfulAction: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    firstname
                    lastname
                    job
                } footer: {
                    if case .validation(let error) = vm.error,
                       let errorDesc = error.errorDescription {
                        Text("\(errorDesc)")
                            .foregroundStyle(.red)
                    }
                }
                
                Section {
                    submit
                }
            }
            .disabled(vm.state == .submitting)
            .navigationTitle("Create")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    done
                }
            }
            .onChange(of: vm.state) { formState in
                if formState == .successful {
                    dismiss()
                    successfulAction()
                }
            }
            .alert(isPresented: $vm.hasError,
                   error: vm.error) {
                Button {
                } label: {
                    Text("Retry")
                }
            }
           .overlay {
               if vm.state == .submitting {
                   ProgressView()
               }
           }
        }
    }
}

extension CreateView {
    enum Field: Hashable {
        case firstName
        case lastName
        case job
    }
}

#Preview {
    // Add empty closure to silence the error
    CreateView {}
}

extension CreateView {
    var done: some View {
        Button {
            dismiss()
        } label: {
            Text("Done")
        }
    }
    
    var firstname: some View {
        TextField("First Name", text: $vm.person.firstName)
            .focused($focusedField, equals: .firstName)
    }
    
    var lastname: some View {
        TextField("Last Name", text: $vm.person.lastName)
            .focused($focusedField, equals: .lastName)
    }
    
    var job: some View {
        TextField("Job", text: $vm.person.job)
            .focused($focusedField, equals: .job)
    }
    
    var submit: some View {
        Button {
            focusedField = nil
            Task {
                await vm.createPerson()
            }
        } label: {
            Text("Submit")
        }
    }
}
