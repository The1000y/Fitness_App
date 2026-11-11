# Profile Module

This module follows **Clean Architecture** and adheres strictly to the architectural conventions of the fitness app (as established in the `auth` module).

---

## 1. Dependency Direction

```
Presentation  ──>  Domain  <──  Data (and Api)
```

* **Domain** is the center of the architecture and has **zero dependencies** on Flutter, presentation, or external data sources/frameworks.
* **Domain must NEVER import from `data/`, `api/`, or `presentation/`.**
* **Presentation** and **Data** depend only on the contracts and entities defined in **Domain**.

---

## 2. Layers & Responsibilities

### `domain/`
The business logic layer of the Profile module.
* **`entities/`**: Pure Dart data classes extending `Equatable`. Represent core business models.
* **`repo/`**: Abstract interfaces (`abstract interface class ProfileRepo`) declaring repository operations.
* **`use_cases/`**: Single-responsibility interactors annotated with `@injectable`. Each use case exposes a `call(...)` method that returns `Future<BaseResponse<T>>`.

### `data/`
The data access layer implementing domain repository contracts.
* **`data_source/remote/`**: Abstract interface contracts for remote data operations (`ProfileRemoteDataSource`).
* **`model/requests/`**: Request DTOs annotated with `@JsonSerializable()` for network payloads.
* **`model/responses/`**: Response DTOs annotated with `@JsonSerializable()` that deserialize JSON and provide `.toEntity()` mapping methods to convert DTOs into domain entities.
* **`repo_impl/`**: Implementations of the domain repository (`ProfileRepoImpl`), coordinating remote data sources and wrapping calls with `excecuteApiCall(...)`. Annotated with `@Injectable(as: ProfileRepo)`.

### `api/`
The network and remote infrastructure layer.
* **`client/`**: Retrofit REST API client (`ProfileApiClient`) annotated with `@singleton` and `@RestApi()`.
* **`data_source/remote/`**: Remote data source implementation (`ProfileRemoteDataSourceImpl`) invoking `ProfileApiClient`. Annotated with `@Injectable(as: ProfileRemoteDataSource)`.

### `presentation/`
The UI layer displaying state and capturing user intent.
* **`manager/`**: State management using `BaseCubit` (`ProfileCubit`), states (`ProfileState` holding `BaseState<ProfileEntity>`), and sealed events (`ProfileEvent`).
* **`view/`**: Root screen widgets (e.g. `ProfileView`).
* **`view/widgets/`**: Reusable presentation widgets scoped to the profile screens.

---

## 3. Naming Rules

1. **Module Prefix**: Every file name inside this module begins with `profile_` (e.g. `profile_get_use_case.dart`, `profile_entity.dart`).
2. **Repository Naming**: Interfaces live under `domain/repo/` ending in `_repo.dart`. Implementations live under `data/repo_impl/` ending in `_repo_impl.dart`.
3. **Use Cases**: Live under `domain/use_cases/` ending in `_use_case.dart`.
4. **Data Sources**: Interfaces live under `data/data_source/remote/`. Implementations live under `api/data_source/remote/`.
5. **Dependency Injection**: Use `injectable` annotations (`@injectable`, `@singleton`, `@Injectable(as: ...)`) and run `dart run build_runner build --delete-conflicting-outputs` to update `di.config.dart`.

