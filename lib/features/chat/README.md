# Chat Module

This module follows **Clean Architecture** principles to separate concerns, ensure testability, and decouple business logic from framework details and external data sources.

## Dependency Direction

```text
Presentation ───► Domain ◄─── Data
                     ▲
                    API
```

- **Domain** is the central, independent core. It contains enterprise business logic, contracts, and entities.
- **Data** depends on **Domain** (implements repository contracts, maps DTOs to entities).
- **Presentation** depends on **Domain** (consumes use cases, repositories, and entities via Cubits/Blocs).
- **Rule:** The `domain` layer must **NEVER** import from `data` or `presentation`.

---

## Layer Responsibilities

### 1. `api/`
- Direct remote communication clients (e.g., Retrofit / Dio clients).
- Handles HTTP definitions, query parameters, endpoints, and low-level transport.

### 2. `data/`
- **`datasource/remote/`**: Remote data source interfaces and their implementations (network calls via the API client).
- **`models/`**: Request and response DTOs (Data Transfer Objects), JSON serialization (`fromJson` / `toJson`), and entity mappers.
- **`repository/`**: Repository implementations (`*_impl.dart`) fulfilling contracts defined in the domain layer.

### 3. `domain/`
- **`entities/`**: Plain Dart data objects representing the core business models (no serialization or framework logic).
- **`repository/`**: Abstract interfaces/contracts specifying what data operations exist.
- **`use_cases/`**: Encapsulated units of business logic orchestrating data from repositories.

### 4. `presentation/`
- **`manager/`**: State management (Cubit / Bloc and State classes) reacting to user events and updating state.
- **`view/`**: Screen-level widgets and views.
- **`view/widget/`**: Reusable component-level widgets scoped to this feature.

---

## Naming Rules

- Files use `snake_case` prefixed with `chat_` (e.g., `chat_api_client.dart`, `chat_cubit.dart`, `chat_view.dart`).
- Repository contracts and implementations use the repository domain name:
  - Contract: `<name>.dart` (e.g., `chat_repository.dart`, `message_repository.dart`)
  - Implementation: `<name>_impl.dart` (e.g., `chat_repository_impl.dart`, `message_repository_impl.dart`)
- Classes use `PascalCase` matching their file intent (e.g., `ChatRepository`, `ChatRepositoryImpl`, `ChatCubit`, `ChatState`).
