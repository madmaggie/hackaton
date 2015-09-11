package caligraph;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.io.File;
import java.util.ArrayList;

import javax.swing.GroupLayout;
import javax.swing.GroupLayout.ParallelGroup;
import javax.swing.GroupLayout.SequentialGroup;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JColorChooser;
import javax.swing.JComboBox;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JToggleButton;
import javax.swing.Timer;
import javax.swing.colorchooser.AbstractColorChooserPanel;

import studentmodel.Student;
import tutormodel.ATIBOView;
import tutormodel.CognitiveEvaluation;
import tutormodel.Tutor;
import tutormodel.VisualTutor;

/**
 * User Interface design
 * @author Mihaela Puica 
 *
 */
/**
 * @author micky
 *
 */
public class CalligraphView extends JFrame implements ActionListener {

	/*public final static String[] simboluri = new String[]{"liniuta mica simpla", "liniuta mica dubla",
		"liniuta mare sus", "liniuta mare jos", "liniuta mare duble", "bastonas mic sus",
		"bastonas mare sus", "bastonas mici jos", "bastonas mare jos", "zala mica",
		"zala mare", "bucla mica", "bucla mare", "carlig", "oval", "bici", "semioval stanga",
		"semioval dreapa", "nodulet mic", "nodulet mre", "Amic", "Amare", "Bmic", "Bmare",
		"Cmic", "Cmare", "Dmic", "Dmare", "Emic", "Emare", "Fmic", "Fmare", "Gmic", "Gmare",
		"Hmic", "Hmare", "Imic", "Imare", "Jmic", "Jmare", "Kmic", "Kmare", "Lmic", "Lmare",
		"Mmic", "Mmare", "Nmic", "Nmare", "Omic", "Omare", "Pmic", "Pmare", "Qmic", "Qmare",
		"Rmic", "Rmare", "Smic", "Smare", "Tmic", "Tmare", "Umic", "Umare", "Vmic", "Vmare",
		"Wmic", "Wmare", "Xmic", "Xmare", "Ymic", "Ymare", "Zmic", "Zmare"};*/
	//public final static String[] calificative = new String[]{"1: Insuficient", "2: Bine", "3: FoarteBine"};
	
	public final static String[] simboluri = new String[]{"Amic", "Amare", "Bmic", "Bmare",
		"Cmic", "Cmare", "Dmic", "Dmare", "Emic", "Emare", "Fmic", "Fmare", "Gmic", "Gmare",
		"Hmic", "Hmare", "Imic", "Imare", "Jmic", "Jmare", "Kmic", "Kmare", "Lmic", "Lmare",
		"Mmic", "Mmare", "Nmic", "Nmare", "Omic", "Omare", "Pmic", "Pmare", "Qmic", "Qmare",
		"Rmic", "Rmare", "Smic", "Smare", "Tmic", "Tmare", "Umic", "Umare", "Vmic", "Vmare",
		"Wmic", "Wmare", "Xmic", "Xmare", "Ymic", "Ymare", "Zmic", "Zmare"};
	
	//public final static String[] calificative = new String[]{"Caracter insuficient achizitionat", "Caracter in curs de achizitionare", "Caracter achizitionat"};
	public final static String[] tipCaiet = new String[] {"Tip 1", "Tip 2", "Dictando", "Matematica"};
	public final static Integer[] grosimeStilou = new Integer[] {1,2,3,4,5};
	public final static int drawingRegionsNo = 3;
	
	
	// Drawing area
	private Paper[] paperView;
	private CalligraphComputations computations;
	private VisualTutor tutor;
	private ATIBOView atiboView;
	//private String studentName;
	private Student student;
	
	private String filename;
	
	private JLabel tipCaietLabel;
	private JComboBox<String> tipCaietCombo;
	private JLabel grosimeStilouLabel;
	private JComboBox<Integer> grosimeStilouCombo;
	private JButton nextButton;
	private JToggleButton eraseButton;
	
	private JLabel topicLabel;
	private int topicIndex;
	
	private JColorChooser penColor;
	
	private Timer timer;
	
	
	public CalligraphView(ATIBOView atiboView) {
		computations = new CalligraphComputations();
		paperView = new Paper[drawingRegionsNo];
		tutor = new VisualTutor();
		filename = "";
		this.atiboView = atiboView;
		
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
		Font biggerFont = new Font("Serif", Font.BOLD, 20);		
		tipCaietLabel = new JLabel("Tip de caiet: ");
		tipCaietLabel.setFont(biggerFont);
		tipCaietCombo = new JComboBox<String>(tipCaiet);
		tipCaietCombo.setFont(biggerFont);
		grosimeStilouLabel = new JLabel("Grosime stilou:");
		grosimeStilouLabel.setFont(biggerFont);
		grosimeStilouCombo = new JComboBox<Integer>(grosimeStilou);
		grosimeStilouCombo.setSelectedIndex(2);
		grosimeStilouCombo.setFont(biggerFont);
				
		nextButton = new JButton();
		nextButton.setIcon(new ImageIcon(
				new ImageIcon("./img/nextButton.png").getImage().getScaledInstance(50, 50,  java.awt.Image.SCALE_SMOOTH)));
		nextButton.addActionListener(this);
		nextButton.setFont(biggerFont);
		
		eraseButton = new JToggleButton("Sterge");
		//eraseButton.addActionListener(this);
		eraseButton.setFont(biggerFont);
		
		topicLabel = new JLabel(simboluri[topicIndex]);
		topicLabel.setFont(new Font("Serif", Font.BOLD, 30));
		
		
		/************************** Add pen color palette *********************/
		
		penColor = new JColorChooser(Color.BLUE);
		
		penColor.setPreviewPanel(new JPanel());
		// Retrieve the current set of panels
		AbstractColorChooserPanel[] oldPanels = penColor.getChooserPanels();

		// Remove panels
		for (int i=0; i<oldPanels.length; i++) {
		    String clsName = oldPanels[i].getClass().getName();
		    if (clsName.equals("javax.swing.colorchooser.DefaultSwatchChooserPanel")) {
		    	continue;
		    }
		    else
		    	penColor.removeChooserPanel(oldPanels[i]);
		}
		
		/* *******   title   ************/
		
		JPanel titlePanel = new JPanel();
		titlePanel.add(topicLabel);

		/* *******   settings   ************/
		
		JPanel settingsPanel = new JPanel();
		//settingsPanel.add(penColor);
		//settingsPanel.add(grosimeStilouLabel);
		//settingsPanel.add(grosimeStilouCombo);
		settingsPanel.add(eraseButton);

		/* *******   tutor   ************/
		
		//JPanel tutorPanel = new JPanel();
		//tutorPanel.setBackground(Color.GREEN);
		//tutorPanel.add(tutor);
		//tutorPanel.add(new JLabel(new ImageIcon(tutor.getImage().getScaledInstance(100, 100,  java.awt.Image.SCALE_SMOOTH))));
		//tutorPanel.setPreferredSize(new Dimension(400,450));

		/* *******   next   ************/
		
		JPanel nextPanel = new JPanel();
		nextPanel.add(nextButton);

		/* *******   paper   ************/
		
		// Retrieve the size of the screen and set the size of the application window to fill the entire screen
		Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
		screenSize.setSize(screenSize.getWidth(), screenSize.getHeight()-50);

		
		// Add the drawing surface to the pane
		JPanel paperPanel = new JPanel();
		paperPanel.setBackground(Color.WHITE);
		GroupLayout groupLayout = new GroupLayout(paperPanel);
		paperPanel.setLayout(groupLayout);
		groupLayout.setAutoCreateContainerGaps(true);
		groupLayout.setAutoCreateGaps(true);
		SequentialGroup horGroup = groupLayout.createSequentialGroup();
		ParallelGroup verGroup = groupLayout.createParallelGroup();
		for (int i=0; i<drawingRegionsNo; i++) {
			System.out.println("[CalligraphView] creez paper " + i);
			Symbol newSymbol = new Symbol();
			newSymbol.setName(simboluri[topicIndex]);
			Dimension paperSize = new Dimension((int)(10*newSymbol.getGridWidth()), (int)(4*newSymbol.getGridHeight()));
			paperView[i] = new Paper(this, newSymbol, paperSize, 0, 3); // default: caiet tip 1, pen thick = 3
			paperView[i].setPreferredSize(paperSize);
			horGroup.addComponent(paperView[i]);
			verGroup.addComponent(paperView[i]);
		}
		groupLayout.setHorizontalGroup(horGroup);
		groupLayout.setVerticalGroup(verGroup);
		//paperPanel.setPreferredSize(new Dimension(4*paperSize.width, 2*paperSize.height));
		
		/*GroupLayout gl = new GroupLayout(new JPanel());
		JLabel label = new JLabel("test");
		JTextField textField = new JTextField();
		JCheckBox caseCheckBox = new JCheckBox();
		JCheckBox wholeCheckBox = new JCheckBox();
		JCheckBox wrapCheckBox = new JCheckBox();
		JCheckBox backCheckBox = new JCheckBox();
		JButton findButton = new JButton("test find");
		JButton cancelButton = new JButton("test cancel");
		
		gl.setHorizontalGroup(gl.createSequentialGroup()
			    .addComponent(label)
			    .addGroup(gl.createParallelGroup(GroupLayout.Alignment.LEADING)
			        .addComponent(textField)
			        .addGroup(gl.createSequentialGroup()
			            .addGroup(gl.createParallelGroup(GroupLayout.Alignment.LEADING)
			                .addComponent(caseCheckBox)
			                .addComponent(wholeCheckBox))
			            .addGroup(gl.createParallelGroup(GroupLayout.Alignment.LEADING)
			                .addComponent(wrapCheckBox)
			                .addComponent(backCheckBox))))
			    .addGroup(gl.createParallelGroup(GroupLayout.Alignment.LEADING)
			        .addComponent(findButton)
			        .addComponent(cancelButton))
			);
		
		gl.setVerticalGroup(gl.createSequentialGroup()
			    .addGroup(gl.createParallelGroup(GroupLayout.Alignment.BASELINE)
			        .addComponent(label)
			        .addComponent(textField)
			        .addComponent(findButton))
			    .addGroup(gl.createParallelGroup(GroupLayout.Alignment.LEADING)
			        .addGroup(gl.createSequentialGroup()
			            .addGroup(gl.createParallelGroup(GroupLayout.Alignment.BASELINE)
			                .addComponent(caseCheckBox)
			                .addComponent(wrapCheckBox))
			            .addGroup(gl.createParallelGroup(GroupLayout.Alignment.BASELINE)
			                .addComponent(wholeCheckBox)
			                .addComponent(backCheckBox)))
			        .addComponent(cancelButton))
			);
		*/
		
		
		

		/* *******   up left (title, settings)   ************/

		JPanel upleftPanel = new JPanel();
		upleftPanel.setLayout(new BorderLayout());
		upleftPanel.add(titlePanel, BorderLayout.NORTH);
		upleftPanel.add(settingsPanel, BorderLayout.CENTER);
		
		/* *******   up (title, settings, tutor)   ************/

		JPanel upPanel = new JPanel();
		upPanel.setLayout(new BorderLayout());
		upPanel.add(upleftPanel, BorderLayout.WEST);
		upPanel.add(tutor, BorderLayout.CENTER);
		//upPanel.setPreferredSize(new Dimension((int)(screenSize.width/2),100));

		/* *******   papers   ************/
		

		//JPanel mainPanel = new JPanel();
		//mainPanel.add(paperPanel);
		
		/* *******   all   ************/
				
		JPanel allPanel = new JPanel();
		allPanel.setLayout(new BorderLayout());
		allPanel.add(upPanel, BorderLayout.NORTH);
		allPanel.add(paperPanel, BorderLayout.CENTER);
		allPanel.add(nextPanel, BorderLayout.EAST);
		//allPanel.setPreferredSize(new Dimension((int)(screenSize.width/2), (int)(screenSize.height/2)));		
		this.getContentPane().add(allPanel);
		setLocation((int)(screenSize.width/10), (int)(screenSize.height/10));
		
		
		addWindowListener(new WindowAdapter() {
	        public void windowClosing(WindowEvent e) {                  
	           /*int returnValue = JOptionPane.showConfirmDialog(CalligraphView.this,
	                     "Esti sigur ca vrei sa inchizi ATIBO?", "Confirm",
	                     JOptionPane.YES_NO_OPTION, JOptionPane.INFORMATION_MESSAGE);
	           if (returnValue == JOptionPane.NO_OPTION) {
	                return;
	           }
	           else {*/
                   //System.exit(0);
	          // }
	        	setVisible(false);
	        	atiboView.setVisible(true);
	        	if (timer != null) {
	        		timer.stop();
	        	}
	        }
		});
		
		
		

		/*this.timer = new Timer(10000, new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				synchronized (Tutor.obj) {
					System.out.println("amu s-a declanshat taimaru");
					Tutor.obj.notify();
				}
				
			}
		});
		
		timer.start();*/
		
	}
	
	@Override
	public void actionPerformed(ActionEvent ae) {
				
		if (nextButton.equals(ae.getSource())) {
			computations.setModelPointList(simboluri[topicIndex]);
			computations.setThresholds("./LitereModel/thresholds/th" + simboluri[topicIndex] + ".txt");
			String answer = "";
			synchronized (Tutor.obj) {
				for (int i=0; i<drawingRegionsNo; i++) {
					if (paperView[i].getSymbol() != null) {
						System.out.println("[CalligraphView] save " + i);
						answer += "letter " + i + ": ";
						
						computations.setSymbol(paperView[i].getSymbol());
						//computations.getSymbol().setName(simboluri[topicIndex]);
						// save similar letters in one folder					
						File folder = new File("./" + student.getUser() + "/" + simboluri[topicIndex]);
						
						if (!folder.exists()) {
							folder.mkdir();
							System.out.println("[CalligraphView] am creat folderul ");
						}
											
						filename = "./" + student.getUser() + "/" + simboluri[topicIndex] + "/" + simboluri[topicIndex] + "_" + System.currentTimeMillis();
						System.out.println("[CalligraphView] file to save to: " + filename);
						computations.save(folder, filename);
							
						try {
							answer += computations.evaluateSymbol() + "\n";
							if (student.getKnowledge() == null) {							
								student.setKnowledge(new ArrayList<CognitiveEvaluation>());
							}
							if (student.getKnowledge() != null && student.getKnowledge().size() < topicIndex+1) {
								CognitiveEvaluation ce = new CognitiveEvaluation(simboluri[topicIndex]);
								student.addCognitiveEvaluation(ce);
							}
							student.getKnowledge().get(topicIndex).addExercise(computations.getCharEval());
						} catch (Exception e) {
							e.printStackTrace();
						}
					}
					else {
						answer += "no letter on region " + (i+1) + "\n";
					}
				}
				JOptionPane.showMessageDialog(this, answer);
				Tutor.obj.notify();
			}
		}
	}
	
	public void reset() {
		for (int i=0; i<drawingRegionsNo; i++) {
			paperView[i].reset();
		}
		if (timer != null)
			timer.restart();
	}

	public JToggleButton getEraseButton() {
		return eraseButton;
	}

	public JColorChooser getPenColor() {
		return penColor;
	}

	public int getTopicName() {
		return topicIndex;
	}

	public void setTopicIndex(int topicIndex) {
		this.topicIndex = topicIndex;
		topicLabel.setText("Nivelul " + topicIndex + " - Litera " + simboluri[topicIndex]);
	}

	public CalligraphComputations getComputations() {
		return computations;
	}

	public Student getStudent() {
		return student;
	}

	public void setStudent(Student student) {
		this.student = student;
	}
	
	public void restarttimer() {
		timer.restart();
	}

	public Paper getPaper(int i) {
		return paperView[i];
	}
	
}


