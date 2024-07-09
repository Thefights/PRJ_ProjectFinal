package DAOs;

import Models.Feedback;
import DB.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {

    public void saveFeedback(Feedback feedback) {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement("INSERT INTO Feedback (name, email, subject, message) VALUES (?, ?, ?, ?)")) {
            ps.setString(1, feedback.getName());
            ps.setString(2, feedback.getEmail());
            ps.setString(3, feedback.getSubject());
            ps.setString(4, feedback.getMessage());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Feedback> getAllFeedbacks() {
        List<Feedback> feedbacks = new ArrayList<>();
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement("SELECT * FROM Feedback");
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Feedback feedback = new Feedback();
                feedback.setId(rs.getInt("id"));
                feedback.setName(rs.getString("name"));
                feedback.setEmail(rs.getString("email"));
                feedback.setSubject(rs.getString("subject"));
                feedback.setMessage(rs.getString("message"));
                feedback.setResponse(rs.getString("response"));
                feedback.setResponded(rs.getBoolean("responded"));
                feedbacks.add(feedback);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return feedbacks;
    }

    public Feedback getFeedbackById(int id) {
        Feedback feedback = null;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement("SELECT * FROM Feedback WHERE id = ?")) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    feedback = new Feedback();
                    feedback.setId(rs.getInt("id"));
                    feedback.setName(rs.getString("name"));
                    feedback.setEmail(rs.getString("email"));
                    feedback.setSubject(rs.getString("subject"));
                    feedback.setMessage(rs.getString("message"));
                    feedback.setResponse(rs.getString("response"));
                    feedback.setResponded(rs.getBoolean("responded"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return feedback;
    }

    public void updateFeedback(Feedback feedback) {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement("UPDATE Feedback SET response = ?, responded = ? WHERE id = ?")) {
            ps.setString(1, feedback.getResponse());
            ps.setBoolean(2, feedback.isResponded());
            ps.setInt(3, feedback.getId());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
