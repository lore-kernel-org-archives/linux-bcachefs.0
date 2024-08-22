Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788621CCEF0
	for <linux-bcachefs@vger.kernel.org>; Thu, 22 Aug 2024 17:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724346015; cv=none; b=rknsHysn+5i225GitOv+Ea1J9W/ea6QyjRvY5NGwPnIVFNtMipwiSdSh0mB+vtJ1KHpp5MGHew4+Ba3xYoyoLwRXSpLGIiF2xgDDW4GOllePBC/gtjvANZlrqs8zJVi5BWV4bPU38or7X10wtxO1HtNDjWDZRhSEh6kJ7u6VFFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724346015; c=relaxed/simple;
	bh=mr/sX7umIb1NorFxFJyX6FmPcEyAvkaZm68pgAWCk7w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R8f/ZT8m7gWrsGCf3alPiQa8n1BY7wkTcK52rBeWqN2/Vnarj637jYgz2/gMpexUs4A/wuC1L1Ag50G6maQ82I2Mwtmy+5LwU7Ag6wCsW33WeYr2Z/uNQ9x9stujrpLdIetRFQFflcuXUDB+eHLUbROjWnH/UwBl6OKVZ2+bN0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fbxplzCE; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fbxplzCE"
Date: Thu, 22 Aug 2024 13:00:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724346011;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mr/sX7umIb1NorFxFJyX6FmPcEyAvkaZm68pgAWCk7w=;
	b=fbxplzCEMKqXnF3Dpof48jxmQuRtZ8PstcxcYZldd3EoeZFRnhINJobC7ic8zEsz2WkU8A
	GIQyseXp1ip3wF71RrO8KfZpeIH+DujnyekPTROEaPquuIpoY9b6HCL5h0UEtQ2/FeIVBK
	MrHSIinRH90VgMOYfqbS2daNBGBCudI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+10b936c5eaee2819b49b@syzkaller.appspotmail.com>
Cc: bfoster@redhat.com, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_fs_journal_stop
Message-ID: <maqwa4yt2u62dbiyqvozfjplxlafrcwqqmvibnjoyazjqqzrsx@tudwer627hm4>
References: <0000000000009bc5fa06185a064d@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000009bc5fa06185a064d@google.com>
X-Migadu-Flow: FLOW_OUT

#syz fix: bcachefs: Change bch2_fs_journal_stop() BUG_ON() to warning
