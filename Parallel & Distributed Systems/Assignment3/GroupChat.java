import java.net.*;
import java.io.*;
import java.util.*;

public class GroupChat {
    private static final String ExitChat = "/bye";
    static String userName;
    static volatile boolean finished = false;

    public static void main(String[] args) {
        if (args.length != 2)
            System.out.println("You need to enter your multicast host & port number>");
        else {
            try {
                InetAddress multicastHost = InetAddress.getByName(args[0]);
                int portNumber = Integer.parseInt(args[1]);
                Scanner scan = new Scanner(System.in);
                System.out.print("Please enter your name: ");
                userName = scan.nextLine();
                System.out.println("Type /help for list of commands");
                MulticastSocket mcSocket = new MulticastSocket(portNumber);

                mcSocket.setTimeToLive(0);
                mcSocket.joinGroup(multicastHost);
                Thread t = new Thread(new ReadThread(mcSocket, multicastHost, portNumber));

                // Spawn a thread for reading messages
                t.start();

                // Sent to the current group
                System.out.println("Start typing messages...");
                while (true) {
                    String message;
                    message = scan.nextLine();
                    if (message.equalsIgnoreCase(GroupChat.ExitChat)) {
                        finished = true;
                        mcSocket.leaveGroup(multicastHost);
                        mcSocket.close();
                        scan.close();
                        break;
                    } else if (message.equalsIgnoreCase("/help")) {
                        System.out.println("Exit application: /bye");

                    } else {
                        message = userName + ": " + message;
                        byte[] buffer = message.getBytes();
                        DatagramPacket datagram = new DatagramPacket(buffer, buffer.length, multicastHost, portNumber);
                        mcSocket.send(datagram);
                    }
                }
            } catch (SocketException se) {
                System.out.println("Error creating socket");
                se.printStackTrace();
            } catch (IOException ie) {
                System.out.println("Error reading/writing from/to socket");
                ie.printStackTrace();
            }
        }
    }
}

class ReadThread implements Runnable {
    private MulticastSocket mcSocket;
    private InetAddress multicastHost;
    private int portNumber;
    private static final int MAX_LEN = 1000;

    ReadThread(MulticastSocket mcSocket, InetAddress multicastHost, int portNumber) {
        this.mcSocket = mcSocket;
        this.multicastHost = multicastHost;
        this.portNumber = portNumber;
    }

    @Override
    public void run() {
        while (!GroupChat.finished) {
            byte[] buffer = new byte[ReadThread.MAX_LEN];
            DatagramPacket datagram = new DatagramPacket(buffer, buffer.length, multicastHost, portNumber);
            String message;
            try {
                mcSocket.receive(datagram);
                message = new String(buffer, 0, datagram.getLength(), "UTF-8");
                if (!message.startsWith(GroupChat.userName))
                    System.out.println(message);
            } catch (IOException e) {
                System.out.println("Application closed!");
            }
        }
    }
}