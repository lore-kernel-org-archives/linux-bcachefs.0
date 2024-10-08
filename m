Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E08D22611
	for <linux-bcachefs@vger.kernel.org>; Tue,  8 Oct 2024 03:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728358348; cv=none; b=fXEwsFy1sfi8kNbnfoHo4HE9qROpl5bvD5kZZZuG0su7aDCMi/7isdWiVEYWBwYuiDUecbFCbRs/y4niCZdMJnpacYRUEVHSPjEccEFaEzXq3udzGvwrqeOieq3FH1z/lhc9hjmb+vD/DymIxnWCJZ/5Lr9e98v1d9sAS8c88lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728358348; c=relaxed/simple;
	bh=BDtIrfrgAlNqZZyIZ2z8LexgjRv414/ZKwQfUfFtdi4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LfmbmAwivOasSrpKhaLFuq1VO1pxP5+V6DqzdIVw2G/97QqhTFMqas4hc1iMiPaIn/HBjOevQkWVVqqVvL3Vn3IMX1SaujFY6qkBXlLD97zFYaAKNoU0iM5Ml0+q79FDWCrzAspMw6jDdQf+nGKkCw32/yZS/urTO/OEJBU2/dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Jrju78v7; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Jrju78v7"
Date: Mon, 7 Oct 2024 23:32:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728358343;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BDtIrfrgAlNqZZyIZ2z8LexgjRv414/ZKwQfUfFtdi4=;
	b=Jrju78v7QwqyaPR+5+R+nxkYHSNF7NwWJlLEdGhDK6YxEiJOgs19IbyLNtwiQon9vnK9et
	A993nSPyk8D0L0kvYYaKo9g6xBvpVXnPkLNrxK/jhHuJt0XgGPMNCjmsj5KP8oSmzrivvf
	M6RBy8oPQTkYT4Jfi5Me3sClWMvcaoY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+a3df02951b3139aec8eb@syzkaller.appspotmail.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] WARNING in __bch2_fsck_err (2)
Message-ID: <t7o7qyvk7eqsr3dgqjrhziaz62hdj77kuuo4lfh2bvbao53msd@3uel6pvgefe2>
References: <6704a172.050a0220.49194.0520.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6704a172.050a0220.49194.0520.GAE@google.com>
X-Migadu-Flow: FLOW_OUT

#syz fix: bcachefs: Fix fsck warnings from bkey validation
