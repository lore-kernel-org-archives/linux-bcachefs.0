Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9526A3BB36
	for <linux-bcachefs@vger.kernel.org>; Mon, 11 Mar 2024 00:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710115233; cv=none; b=VDFO7SehqzznDjKaD1sZw59mUuBfWMLGW1Eh9/JJb6kP2l93zWLUafdZGvYaRJlXn49rL4XDlNUt2zMibO8maaxoiqrPnTi8cNgvaNoKuGFEyEGfJufqcFLNM0Xg2jjdChuh7SGTAuiaGCgA+swIPvsBCEASuNNMGh5ocDAdj88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710115233; c=relaxed/simple;
	bh=+yDD08WUJWVj90tmydXaHQGrn6hOhO/u5npE/Lp3q2I=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=TD91R29K+CN1wQX+CC5BrRwDmhvyzOsCGc+gQkv4LTEWZ2gKiOnl7O+9N0HA4rfIzDNJF7YYcbSoKGOvcqAwFLgEIGUXW8qFazbl0SBKdREbcEE8SoWV2v0fNA4XnlnDd10Xbu0QZU6Sy1d3p+/tZV2B+zp/FaicIL5rxcW3DG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iQmUVaA5; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iQmUVaA5"
Date: Sun, 10 Mar 2024 20:00:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1710115229;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=+yDD08WUJWVj90tmydXaHQGrn6hOhO/u5npE/Lp3q2I=;
	b=iQmUVaA5ohFz+ZMs8pPQMoOCTX0Qv11lzykZvS5XyUdmk3IQP/bwVaIgBUkxyAD9dk8RQ3
	ZBlOKESPaaLntoG40kaJBC0j6hepv5gcqAkFxES7sX/DYaWviDNEoPZ/gimLkhqaL2lfsw
	TzXkE/FmJ2V1IAN/JkIxo2l0T+PoMIM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Tiezhu Yang <yangtiezhu@loongson.cn>, 
	Guo Xuenan <guoxuenan@huawei.com>, Rajat Asthana <thisisrast7@gmail.com>, 
	Gao Xiang <xiang@kernel.org>, Nick Terrell <terrelln@fb.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: lz4 hc buffer overflow
Message-ID: <js2vmwcgwyx5kxq3csunc3piwkpfsebg3u2zewok6iis5wgn2e@eyy4fzryskj7>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT

reference https://github.com/koverstreet/bcachefs/issues/658

It looks like something is off with the bounds checking in LZ4 HC; I
haven't dug too deep yet. Never saw this with regular LZ4.

Anyone know anything? Are we missing a fix from the userspace library?
