package tutormodel;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Font;
import java.awt.GridBagLayout;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;

import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;

import caligraph.CalligraphView;
import domainmodel.Course;

public class ATIBOView extends JFrame implements ActionListener {
	
	private VisualTutor tutor;
	private JButton caligraphButton;
	private CalligraphView view;
	private int courseType;
	
	public ATIBOView() {
		tutor = new VisualTutor();
		
	    setLocation(0, 0);
		setTitle("ATIBO");
		setBackground(Color.lightGray);
		setIconImage(new ImageIcon("img/atibo.jpg").getImage());
		setLayout(new BorderLayout());
		setDefaultCloseOperation(JFrame.DO_NOTHING_ON_CLOSE);
		build();
		pack();
		setVisible(true);		
	}
	
	private void build() {
		Font biggerFont = new Font("Serif", Font.BOLD, 40);	
		JLabel titleLabel = new JLabel("ATIBO");
		titleLabel.setFont(biggerFont);
		JLabel subtitleLabel = new JLabel("Animated Intelligent Tutor in the Box");
		subtitleLabel.setFont(biggerFont);
		JPanel titlePanel = new JPanel();
		titlePanel.setLayout(new GridLayout(2,1));
		titlePanel.add(titleLabel);
		titlePanel.add(subtitleLabel);		
		
		caligraphButton = new JButton("Calligraphy");
		caligraphButton.addActionListener(this);
		JPanel buttonPanel = new JPanel();
		buttonPanel.add(caligraphButton);
		
		//JLabel tutorLabel = new JLabel(new ImageIcon("img/tutor.bmp"));
		
		JPanel mainPanel = new JPanel();
		mainPanel.setLayout(new BorderLayout());
		mainPanel.add(titlePanel, BorderLayout.NORTH);
		mainPanel.add(tutor, BorderLayout.CENTER);
		mainPanel.add(buttonPanel, BorderLayout.SOUTH);
		
		getContentPane().add(mainPanel);
		
		addWindowListener(new WindowAdapter() {
	        public void windowClosing(WindowEvent e) {                  
	           /*int returnValue = JOptionPane.showConfirmDialog(CalligraphView.this,
	                     "Esti sigur ca vrei sa inchizi ATIBO?", "Confirm",
	                     JOptionPane.YES_NO_OPTION, JOptionPane.INFORMATION_MESSAGE);
	           if (returnValue == JOptionPane.NO_OPTION) {
	                return;
	           }
	           else {*/
                   System.exit(0);
	          // }
	        }
		});
	}
	
	@Override
	public void actionPerformed(ActionEvent ae) {
		if (ae.getSource().equals(caligraphButton)) {
			courseType = Course.CALLIGRAPHY;
			synchronized (Tutor.obj) {
				if (view == null) {
					view = new CalligraphView(this);
				}
				else {
					synchronized (Tutor.obj) {
						view.setVisible(true);
						view.restarttimer();
						//Tutor.obj.notify();
					}
				}
				setVisible(false);
				Tutor.obj.notify();
			}
		}
	}

	public CalligraphView getView() {
		return view;
	}

	public void setView(CalligraphView view) {
		this.view = view;
	}

	public int getCourseType() {
		return courseType;
	}

	public void setCourseType(int courseType) {
		this.courseType = courseType;
	}
		
}
