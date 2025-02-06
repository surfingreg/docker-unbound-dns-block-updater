# > docker rm unbound_updater; docker build -t unbound_updater .; docker run unbound_updater
FROM rust
WORKDIR /app
RUN git clone https://github.com/surfingreg/rust-unbound-dns-block.git
WORKDIR /app/rust-unbound-dns-block
# more here: https://github.com/surfingreg/rust-unbound-dns-block
RUN cargo install --example naive --path .
CMD ["naive"]