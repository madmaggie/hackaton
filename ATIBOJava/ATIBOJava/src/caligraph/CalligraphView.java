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

import javax.swing.BorderFactory;
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
import javax.swing.border.Border;
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
	
	
	// Drawing area
	private Paper[] paperView;
	private CalligraphComputations computations;
	private VisualTutor tutor;
	private ATIBOView atiboView;
	private Student student;
	
	private String filename;
	
	private JButton nextButton;
	private JToggleButton eraseButton;
	private Paper topicPaper;
	
	private int topicIndex;
	
	private JColorChooser penColor;
	
	private Timer timer;
	
	private int drawingRegionsX;
	private int drawingRegionsY;
	
	Dimension screenSize, paperSize;
	
	
	public CalligraphView(ATIBOView atiboView) {
		computations = new CalligraphComputations();
		tutor = new VisualTutor();
		//filename = "";
		this.atiboView = atiboView;
		penColor = new JColorChooser(Color.BLUE);

		// Retrieve the size of the screen
		screenSize = Toolkit.getDefaultToolkit().getScreenSize();

		System.out.println("[CalligraphView] screensize: " + screenSize.getWidth() + "," + screenSize.getHeight());
		// Size of the box where a letter should be written
		paperSize = new Dimension((int)(5*Symbol.DEFAULT_WIDTH), (int)(4*Symbol.DEFAULT_HEIGHT));
		
		drawingRegionsX = (int)Math.floor((screenSize.getWidth()-tutor.getWidth())/paperSize.getWidth());
		drawingRegionsY = (int)Math.floor(screenSize.getHeight()/paperSize.getHeight());
		paperView = new Paper[drawingRegionsX*drawingRegionsY];
		System.out.println("[CalligraphView] drawingRegionsX="+drawingRegionsX+" drawingRegionsY="+drawingRegionsY);
		
	    setLocation(0, 0);
		setTitle("ATIBO");
		setBackground(Color.lightGray);
		setIconImage(new ImageIcon("img/atibo.jpg").getImage());
		setLayout(new BorderLayout());
		setDefaultCloseOperation(JFrame.DO_NOTHING_ON_CLOSE);
		setResizable(false);
		build();
		pack();
		setVisible(true);		
	}
	
	private void build() {
		//Font biggerFont = new Font("Serif", Font.BOLD, 20);		
					
		nextButton = new JButton();
		nextButton.setIcon(new ImageIcon(
				new ImageIcon("./img/nextButton.png").getImage().getScaledInstance(50, 50,  java.awt.Image.SCALE_SMOOTH)));
		nextButton.addActionListener(this);
		
		eraseButton = new JToggleButton();
		eraseButton.setIcon(new ImageIcon(
				new ImageIcon("./img/eraser.png").getImage().getScaledInstance(50, 50,  java.awt.Image.SCALE_SMOOTH)));
		
				
		/* *******   title   ************/
		
		topicPaper = new Paper(this, null, paperSize, 0, 3);
		if (filename != null && !filename.isEmpty())
			topicPaper.drawCharacter(filename);
		
		System.out.println("[CalligraphView] topicPaper width = " + topicPaper.getWidth() +
							" topicPaper height = " + topicPaper.getHeight());
		
		JPanel titlePanel = new JPanel();
		titlePanel.add(topicPaper);
		titlePanel.setBorder(BorderFactory.createBevelBorder(0));


		/* *******   tutor   ************/
		
		JPanel tutorPanel = new JPanel();
		tutorPanel.add(tutor);


		/* *******   settings   ************/
		
		JPanel settingsPanel = new JPanel();
		settingsPanel.add(eraseButton);
		settingsPanel.add(nextButton);
		
		
		/* *******   up (title, tutor, settings)   ************/

		JPanel leftPanel = new JPanel();
		leftPanel.setLayout(new BorderLayout());
		leftPanel.add(titlePanel, BorderLayout.NORTH);
		leftPanel.add(tutorPanel, BorderLayout.CENTER);
		leftPanel.add(settingsPanel, BorderLayout.SOUTH);
		//upPanel.setPreferredSize(new Dimension((int)(screenSize.width/2),100));


		/* *******   paper   ************/		
		
		// Add the drawing surfaces to the pane
		JPanel paperPanel = new JPanel();
		//paperPanel.setBackground(Color.WHITE);
		GroupLayout groupLayout = new GroupLayout(paperPanel);
		paperPanel.setLayout(groupLayout);
		groupLayout.setAutoCreateContainerGaps(true);
		groupLayout.setAutoCreateGaps(true);
		SequentialGroup horSeqGroup = groupLayout.createSequentialGroup();
		SequentialGroup verSeqGroup = groupLayout.createSequentialGroup();
		
		
		for (int i=0; i<drawingRegionsX; i++) {
			ParallelGroup horParGroup = groupLayout.createParallelGroup();
			for (int j=0; j<drawingRegionsY; j++) {
				Symbol newSymbol = new Symbol();
				newSymbol.setName(simboluri[topicIndex]);
				paperView[drawingRegionsY*i+j] = new Paper(this, newSymbol, paperSize, 0, 3); // default: caiet tip 1, pen thick = 3
				//paperView[drawingRegionsX*i+j].setPreferredSize(paperSize);
				System.out.print("\t" + (drawingRegionsY*i+j));
				horParGroup.addComponent(paperView[drawingRegionsY*i+j]);
			}
			horSeqGroup.addGroup(horParGroup);
			System.out.println();
		}
		groupLayout.setHorizontalGroup(horSeqGroup);
		
		System.out.println();

		for (int i=0; i<drawingRegionsY; i++) {
			ParallelGroup verParGroup = groupLayout.createParallelGroup();
			for (int j=0; j<drawingRegionsX; j++) {
				System.out.print("\t" + (drawingRegionsY*j+i));
				verParGroup.addComponent(paperView[drawingRegionsY*j+i]);
			}
			verSeqGroup.addGroup(verParGroup);
			System.out.println();
		}		
		groupLayout.setVerticalGroup(verSeqGroup);
		
		System.out.println();
		
		//paperPanel.setSize(new Dimension((int)(paperSize.getWidth()*drawingRegionsX),(int)(paperSize.getHeight()*drawingRegionsY)));
		paperPanel.setBorder(BorderFactory.createBevelBorder(0, Color.BLUE, Color.YELLOW));
		
		
		/* *******   all   ************/
				
		JPanel allPanel = new JPanel();
		allPanel.setLayout(new BorderLayout());
		allPanel.add(leftPanel, BorderLayout.WEST);
		allPanel.add(paperPanel, BorderLayout.CENTER);
		this.getContentPane().add(allPanel);
		
		
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
				for (int i=0; i<drawingRegionsX*drawingRegionsY; i++) {
					if (paperView[i].getSymbol() != null && paperView[i].getSymbol().getPoints().size() > 0) {
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
		//topicPaper.reset();
		for (int i=0; i<drawingRegionsX*drawingRegionsY; i++) {
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
		//topicLabel.setText("Nivelul " + topicIndex + " - Litera " + simboluri[topicIndex]);
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
		if (timer !=null)
			timer.restart();
	}

	public Paper getPaper(int i) {
		return paperView[i];
	}

	public String getFilename() {
		return filename;
	}

	public void setFilename(String filename) {
		this.filename = filename;
		topicPaper.drawCharacter(filename);
	}

	public Paper getTopicPaper() {
		return topicPaper;
	}

	public void setTopicPaper(Paper topicPaper) {
		this.topicPaper = topicPaper;
	}
}


