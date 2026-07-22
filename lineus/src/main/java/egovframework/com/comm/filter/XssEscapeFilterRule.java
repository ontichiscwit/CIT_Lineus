package egovframework.com.comm.filter;

import egovframework.com.comm.filter.defender.Defender;

public class XssEscapeFilterRule {
	private String name;
	private boolean useDefender = true;
	private Defender defender;
	private boolean usePrefix = false;

	/**
	 * @return String
	 */
	public String getName() {
		return name;
	}

	/**
	 * @param name String
	 * @return void
	 */
	public void setName(String name) {
		this.name = name;
	}

	/**
	 * @return boolean
	 */
	public boolean isUseDefender() {
		return useDefender;
	}

	/**
	 * @param useDefender boolean
	 * @return void
	 */
	public void setUseDefender(boolean useDefender) {
		this.useDefender = useDefender;
	}

	/**
	 * @return Defender
	 */
	public Defender getDefender() {
		return defender;
	}

	/**
	 * @param defender Defender
	 * @return void
	 */
	public void setDefender(Defender defender) {
		this.defender = defender;
	}

	/**
	 * @return boolean
	 */
	public boolean isUsePrefix() {
		return usePrefix;
	}

	/**
	 * @param usePrefix boolean
	 * @return void
	 */
	public void setUsePrefix(boolean usePrefix) {
		this.usePrefix = usePrefix;
	}

}
