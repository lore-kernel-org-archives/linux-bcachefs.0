Received: from sunucu.ihale.com.tr (unknown [95.173.178.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490D235F5E1
	for <linux-bcachefs@vger.kernel.org>; Mon,  5 Oct 2026 06:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.173.178.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791182285; cv=none; b=IPRL7imrW9YHZmRmktgXUphV3kl2STwlf1ScJOjzmNl8xfhSCWIgBebeiubbFnrtdDJ3HNUiCj3t52Q0uSrkVWO4EW6eX8F7FZM25dLedhy+YCVo0RrAAgA4pe2sFAw0GV89+rCvqdjMDe9ZsaXfO1UoTrDTcqBPxoaR4slqqhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791182285; c=relaxed/simple;
	bh=GCuqivoAUOuohjs7VuXXiIbk8atlNTAptE1Sgr60/eU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=TJyoVyl3Yqf43hx44TMKsBYNupEDGYmDcVNItAN5nQH2P6kQubsvR3y9QO/bm3XlPg4/F3EA76UeK39nsA66j376ZYWnkL96TDOLE8WBl/GE14OhC7D3zZN/EqQtAaAuyh0EATOorYr5IGwOSFoUGegAWizZNXzWhCBpARmTYm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=legendhomework.com; spf=pass smtp.mailfrom=legendhomework.com; dkim=pass (2048-bit key) header.d=legendhomework.com header.i=@legendhomework.com header.b=CL7CwMTm; arc=none smtp.client-ip=95.173.178.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=legendhomework.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=legendhomework.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=legendhomework.com header.i=@legendhomework.com header.b="CL7CwMTm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=legendhomework.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:To:From:Reply-To:Sender:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Unsubscribe-Post:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=5lmJJ0mEKCC15dQaupFmVY6/ZNMzkad8UFLiXk6+8uk=; b=CL7CwMTmxFNkBTLlqpdhrieuw5
	jwo719mGfO+vCjrqzHr2kMDCO8UW/l7tET0H3Ebkp0FZl7z63wxSTbRlRpgywu7E0t4t6MUZiNCxv
	cK9dR72G+Xr9i71vkXX1DBQXAoxsULcVkd4lK8NSBPM8U1l16M8SNsZCuXlonmQpHr8MAD/19uXy5
	Dtsix1/5SIN2Kf9+w/EMT+4x0zoB5kSeDSR6wyZr++9QVF3Tj0CWncFff3+dc39wT6SPBoloZhvO7
	Aof48MEbF4q2GcSv6bz3Ws/CUsZeUf58HkDcxUHcKhe3SBsnSnlXbxavmdEcjmrxsrhhZRcCzw3ky
	wxMo0whA==;
Received: from [154.120.97.226] (port=65237 helo=legendhomework.com)
	by 95-173-178-186.cprapid.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.100.1)
	(envelope-from <info-llhm@legendhomework.com>)
	id 1xDcKd-0000000CPnR-3LEW
	for linux-bcachefs@vger.kernel.org;
	Mon, 05 Oct 2026 09:37:54 +0300
Reply-To: perrymail@tutamail.com
From: info-llhm@legendhomework.com
To: linux-bcachefs@vger.kernel.org
Subject: Your Consent
Date: 04 Oct 2026 23:37:54 -0700
Message-ID: <20261004233754.6F6FCF41C1552252@legendhomework.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - 95-173-178-186.cprapid.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - legendhomework.com
X-Get-Message-Sender-Via: 95-173-178-186.cprapid.com: authenticated_id: info-llhm@legendhomework.com
X-Authenticated-Sender: 95-173-178-186.cprapid.com: info-llhm@legendhomework.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 

Greetings,

My name is Dr. Innocent Bariate Barikor, Director-General of the=20
National Environmental Standards and Regulations Enforcement=20
Agency Nigeria - (NESREA).

As part of my official responsibilities, I monitor environmental=20
compliance and pollution associated with oil and gas exploration,=20
drilling, and production activities in the Niger Delta and=20
submits relevant findings to the Presidency.

In the course of carrying out these responsibilities, my=20
investigations identified significant environmental compliance=20
concerns involving four major oil-producing companies:

1.      Shell Petroleum Development Company Limited

2.      Mobil Producing Nigeria Unlimited / Esso Exploration &=20
Production Nigeria Limited

3.      Chevron Nigeria Limited / Texaco Overseas

4.      Elf Petroleum Limited / Total Exploration Limited.

The four companies were subsequently assessed penalties of=20
US$1.2Billion, with the applicable sanctions providing for the=20
potential revocation of their operating licenses in the event of=20
non-compliance. Given the importance of their operating licenses=20
to their continued activities in Nigeria, the four companies=20
appealed for a reduction or waiver of the assessed penalties.=20
Their requests were subsequently considered by the Federal=20
Government, and the applicable fines were reduced to US$800=20
Million.

The companies have since settled the revised penalties with the=20
Ministry of Environment. They have also indicated their intention=20
to provide a US$50,000,000.00 payment in recognition of my role=20
in the process. However, as a senior public official, I am=20
subject to the applicable Code of Conduct and therefore cannot=20
maintain or operate a foreign bank account for the receipt of=20
such funds. Consequently, I am unable to provide a foreign=20
account for this purpose. In view of the foregoing, I am unable=20
to personally receive or facilitate the transfer of any such=20
payment because of the restrictions applicable to my position as=20
a public official.

I therefore seek your assistance in identifying a resourceful and=20
transparent mechanism through which the matter in relation to the=20
gratification can be addressed without any traces to me=20
considering the fact that I am still in active service. Any=20
proposed arrangement should be properly documented and, where=20
required, discussed with a financial facilitator locally without=20
mentioning names; so that all parties are adequately protected=20
and the transaction is handled through the proper channels.

I would appreciate your guidance and cooperation in resolving=20
this matter in a manner that is fully compliant with existing=20
financial regulations.

Best regards,

Dr. Innocent Bariate Barikor
Director General
NESREA.
Direct Phone/Whatsapp: +2349019779152
