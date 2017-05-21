# bs-gcloud
Google Cloud Datastore bindings of BuckleScript.

```
npm i --save bs-gcloud
```

# example

```
  let module Ds = Gcloud.Datastore in
  let ds = Ds.datastore () in
```

```
  let key = ds##key ("Book", "First") in
  ds##get key begin fun[@bs] err entity ->
    match Js.Undefined.to_opt entity with
    | None -> Js.log err
    | Some entity -> Js.log entity
  end
```
