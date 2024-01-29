Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13AEBFBE8
	for <linux-bcachefs@vger.kernel.org>; Mon, 29 Jan 2024 02:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706495024; cv=none; b=AAuNtS7LsZJIOPN9KYb5b6eM+3Yn+wj6cW/o2zO/TIF8SYZORVI41smA9Y4joc58aegqLkpbjRIk8vCqUCTS+xgeCBu9AIyLztx3gspwlq5OtuvKOXC2jLM/3+xu/6ZsFtaGrFzoVrqQIZZRZhc5o8KiHWXX2bvT8uLJ7rrwTjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706495024; c=relaxed/simple;
	bh=FQlOwLn2ocNBEv5gE+AFCZWo/cwJ2DTbBSlQP0qTBhc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NRfIKelCdDqM7IfkzFBp812+HPKeL+UwPk5lGb8df3cAm6kI/YI9Pp9a2bv+Y5Idvw5qyFrh/R1Sgmdu4/BjaVSslL5ijxwkakFIVxSuKIBQZX/BIh4PNayEDTT3Oh2y9tAMZ9xVOi8OIATQorjVpc+3VuzwSQs9I4TOhdJuW4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=jLZ4JJ8T; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="jLZ4JJ8T"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FQlOwLn2ocNBEv5gE+AFCZWo/cwJ2DTbBSlQP0qTBhc=; b=jLZ4JJ8TwH9fNQCyu85GcAnFN1
	AKUVP/Bg7cwQHxWeN5mv/3XWhWFLUzhGWiFeWChyjq4xyXjZuj34UDMEWlS9nvmYvEpDty2hV1y5m
	ZIRhCyRgTEVy882CIJ87eYFI1Eof6qQSp0ZjH2VUu1DEWyFC++aw0PW6Osb43ZGTGJWpUtjZhBdhk
	9oLTrg3ePATV2lTJhayyKyOZIESF0I2YoHgs5eOU7FhooCQdgQ2nIAtyEyO8VhAd3bwT+h8JXf3OI
	HGI1KCvRpyILnok2+Tajb60kV9SQk/FzgsXL2Ig9bOCK9Rj/xRAljMFNVz+GBJ6Ygu8zUQGNzZalv
	F/W/jIlQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rUHJC-0006Lk-1Z;
	Mon, 29 Jan 2024 02:23:38 +0000
Date: Mon, 29 Jan 2024 02:23:38 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Guoyu Ou <benogy@gmail.com>, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: unlock parent dir if entry is not found in
 subvolume deletion
Message-ID: <20240129022338.GH2087318@ZenIV>
References: <20240128084617.244234-1-benogy@gmail.com>
 <ihz24ycxt7vipgup5din2y4oz74ndekkgwuyckuxnibm5bnyat@t7lggqpno26l>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ihz24ycxt7vipgup5din2y4oz74ndekkgwuyckuxnibm5bnyat@t7lggqpno26l>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Sun, Jan 28, 2024 at 09:21:48PM -0500, Kent Overstreet wrote:

> How do we feel about the following?

No, with side of Fuck, NO.
