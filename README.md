# Control Room Go SDK

Go client for the [Control Room API](https://getcontrolroom.com). Generated from `spec/openapi.yaml` using [oapi-codegen](https://github.com/oapi-codegen/oapi-codegen).

## Installation

```bash
go get github.com/getcontrolroom/sdk-go
```

## Quick Start

```go
import (
    "context"
    crsdk "github.com/getcontrolroom/sdk-go"
)

client, err := crsdk.NewClientWithResponses("https://api.getcontrolroom.com")
if err != nil {
    log.Fatal(err)
}

resp, err := client.ListBookingsWithResponse(context.Background(), &crsdk.ListBookingsParams{})
```

## Auth

**Service-to-service** (app → api):

```go
import "net/http"

type serviceAuth struct {
    userID string
    secret string
}

func (a serviceAuth) Intercept(ctx context.Context, req *http.Request) error {
    req.Header.Set("X-User-Id", a.userID)
    req.Header.Set("X-Service-Secret", a.secret)
    return nil
}

client, _ := crsdk.NewClientWithResponses(
    "https://api.getcontrolroom.com",
    crsdk.WithRequestEditorFn(serviceAuth{userID, secret}.Intercept),
)
```

**Bearer token**:

```go
client, _ := crsdk.NewClientWithResponses(
    "https://api.getcontrolroom.com",
    crsdk.WithRequestEditorFn(func(ctx context.Context, req *http.Request) error {
        req.Header.Set("Authorization", "Bearer "+token)
        return nil
    }),
)
```

## Timeouts

`http.DefaultClient` has no timeout. Always pass a custom client with a deadline:

```go
import "net/http"
import "time"

httpClient := &http.Client{Timeout: 30 * time.Second}

client, _ := crsdk.NewClientWithResponses(
    "https://api.getcontrolroom.com",
    crsdk.WithHTTPClient(httpClient),
)
```

Prefer per-request context deadlines for finer control:

```go
ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
defer cancel()

resp, err := client.GetBookingWithResponse(ctx, bookingID)
```

## Regenerating

Requires [oapi-codegen](https://github.com/oapi-codegen/oapi-codegen) and the spec at `../spec/openapi.yaml`.

```bash
make generate   # regenerate client.gen.go
make tidy       # go mod tidy
```

## License

MIT — see [LICENSE](LICENSE).
