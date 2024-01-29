Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79FBC3D76
	for <linux-bcachefs@vger.kernel.org>; Mon, 29 Jan 2024 02:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706495428; cv=none; b=iy7AmocxwR0CSIOFVJqfuclHDOAloBt32yRSzmJIfemh/Vod0sgoIWL8Hh+Bab5rhs+xXcoRdwZ/CHgEyLuly9rotmXWYLv3Q6IQjOkXGSTVbbAhFgK15X68jQUV2m4W06NlifHtfkzjbZvrs5F5nGL1WsrTwzMZQovy4RlazPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706495428; c=relaxed/simple;
	bh=e6SjfyY60KADw4b9J1Yb1AuYUPNRw3k4VCrq8gklhLs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BPfcSraVvfYv03qWT+7O+uWboCBZSANq1i/j8JEhz2I1Cq+wtB/YDVaZavBIC2iqG2Qy0sYQnTVBuLqBiT+otMHO2wrFd7E0KxsCXgRfxgy6j6gCz2hr8IQjLo9svPfTXDJtk9M6wIEy4h4NGItboaDbw+yidnSpguYs4Bz6+AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=eOQHbCPJ; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="eOQHbCPJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=e6SjfyY60KADw4b9J1Yb1AuYUPNRw3k4VCrq8gklhLs=; b=eOQHbCPJwO390vVi5N7M3xobku
	ZBGggb7T4Ysaviil4bFTHTQAfSslrNHXS+Usyy1/YJei7ugEXTWnI9FBJgxaTsDl8x4pyo32Lcvlg
	PoaFaNG1kheDrER77CAZtlDdNpljWgG15KUlEG4WzEtWngUbo1356fg+1Nx8W+QkNTYoGuHEC7mpJ
	ci1i9BP0qAPeb1OjVPZpja4J2tJRQT0Mceoair3Gwy5N0alfwTvp9+dH3nl6at86oZ1kiFm4wy7xv
	/JzAY6P87lkeCf+UNGG8tpjpjGetyqlzBl9i5pfjWXa1CfuSUycgYInPVZuCGQ6DmY1fh6qTODuuk
	UmViBw7A==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rUHPj-0006RD-2q;
	Mon, 29 Jan 2024 02:30:23 +0000
Date: Mon, 29 Jan 2024 02:30:23 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Guoyu Ou <benogy@gmail.com>, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: unlock parent dir if entry is not found in
 subvolume deletion
Message-ID: <20240129023023.GI2087318@ZenIV>
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

> Your fix works, but having user_path_locked_at() return an object that
> we have a destructor for but needs extra cleanup is not ideal, and now
> that I look I'm also wondering why the dput(victim) is necessary when
> path_put() also does a dput().

Because victim is not equal to path.dentry, perhaps?
