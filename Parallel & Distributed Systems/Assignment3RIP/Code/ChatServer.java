import java.io.*;
import java.net.*;
import java.util.*;

public class ChatServer {
    private int port;
    // Keep track of user names
    private Set<String> userNames = new HashSet<>();
    // Keep track of user threads
    private Set<UserThread> userThreads = new HashSet<>();

    public ChatServer(int port) {
        this.port = port;
    }

    public void execute() {
        try (ServerSocket serverSocket = new ServerSocket(port)) {
            System.out.println("Chat server is on port " + port);

            while (true) {
                Socket socket = serverSocket.accept();
                System.out.println("New user connected");

                UserThread newUser = new UserThread(socket, this);
                userThreads.add(newUser);
                newUser.start();
            }
        } catch (IOException ex) {
            System.out.println("Error in the server: " + ex.getMessage());
            ex.printStackTrace();
        }
    }

    public static void main(String[] args) {
        if (args.length < 1) {
            System.out.println("Syntax: java ChatServer <port-number>");
            System.exit(0);
        }

        int port = Integer.parseInt(args[0]);

        ChatServer server = new ChatServer(port);
        server.execute();
    }

    // Send a message from one user to others
    void broadcast(String message, UserThread excludeUser) {
        for (UserThread aUser : userThreads) {
            if (aUser != excludeUser) {
                aUser.sendMessage(message);
            }
        }
    }

    // Stores username of new user
    void addUserName(String userName) {
        userNames.add(userName);
    }

    // When user disconnects - remove user name and user thread
    void removeUser(String userName, UserThread aUser) {
        boolean removed = userNames.remove(userName);
        if (removed) {
            userThreads.remove(aUser);
            System.out.println(userName + " has left");
        }
    }

    Set<String> getUsernames() {
        return this.userNames;
    }

    // Retunr strue if more than 1 user connected
    boolean hasUsers() {
        return !this.userNames.isEmpty();
    }

}