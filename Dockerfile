#Create a base image
FROM golang:1.22 as base
 
#set a working directory
WORKDIR /app
 
#Copy the go.mod file to working directory
COPY go.mod ./
 
#Download all dependencies
RUN go mod Download
 
#Copy the source code to the working directory
COPY . .
 
#Build the application
RUN go build -o main
 
#################################################
 
#Reduce the image size using distroless image
FROM gcr.io/distroless/base
 
#Copy the binary from the previous stage
COPY --from=base /app/main .
 
#Similarly copy the static files
COPY --from=base /app/static .
 
#Expose the port
EXPOSE 8080
 
#Run the application
CMD ["./main"]
