import SwiftUI

struct LogBookView: View {

    @EnvironmentObject var viewModel: LogbookViewModel

    var body: some View {
        List {
            if viewModel.tops.isEmpty {
                ContentUnavailableView(
                    "No Tops Yet",
                    systemImage: "figure.climbing",
                    description: Text("Start logging your sends!")
                )
            }

            ForEach(viewModel.tops.reversed()) { top in
                NavigationLink(destination:
                    EditTopView(top: top)
                        .environmentObject(viewModel)
                ) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(top.boulderName)
                                .font(.headline)
                            Text("Grade: \(top.grade)")
                                .font(.subheadline)
                            Text(top.date.formatted(date: .abbreviated, time: .omitted))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Image(systemName: "square.and.pencil")
                    }
                    .padding(.vertical, 4)
                }
            }

            .onDelete { offsets in
                Task {
                    await viewModel.delete(at: offsets)
                }
            }
        }
        .navigationTitle("Logbook")
        .toolbar {
            NavigationLink {
                AddTopView()
                    .environmentObject(viewModel)
            } label: {
                Image(systemName: "plus")
            }
        }
    }
}
