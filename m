Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C683D2C190
	for <linux-bcachefs@vger.kernel.org>; Thu, 22 Aug 2024 16:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724345973; cv=none; b=BFiEaxgHoHa+vba0Lm5OBEyRSSyWImQ34RevnhZWV0Ys34h9GyIKu/632nxC23BZKct7J60J/1u9QLrmoXViqMEpOHAhrEmZB1OOlcbvdp9LyOW6d4CGR7C/04QSfN+0q/s8V8pyCPEZd6LVZcBgcJvk+9DUrHNC4NbbzxrzMUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724345973; c=relaxed/simple;
	bh=AW++XKit1WHfeU58FY8eMWTsW+yYqpgpPrvGly/aR+s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DfCxal6sSgXCBGkArNemsbhl09wLkXDUU4rMnuw8VMl/r3DGED0PugmDnbuDr4+R4aAIYdYLhCsf8Urmzul+TIgBKSBP1nX2ISxu3qpYLnM2lGLGLLP3dRszXsHsGeoHVlBef2UTOUuMfm7CthF/D2opgzwkH67DpWQ2lpWfHe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WGmpPqUl; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WGmpPqUl"
Date: Thu, 22 Aug 2024 12:59:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724345969;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AW++XKit1WHfeU58FY8eMWTsW+yYqpgpPrvGly/aR+s=;
	b=WGmpPqUlieeJLFRWGMNic5Qoi/PkXH8JAgd0DDnL2g4lgnIzopg8Xex/8Rtx+sm6TrM62D
	lmkYwiJ4IhNITObTy2Nk005fUNgnjh8aGVtpZujjtDprw2bx+ldy2SihDWUWcx8jihCMlg
	eY3aYfBWDiBLKS7sJqXrNQNpJEIY5Us=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+4093905737cf289b6b38@syzkaller.appspotmail.com>
Cc: bfoster@redhat.com, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] WARNING in bch2_fs_journal_stop
Message-ID: <gtlnzycgrdx7ovjq3noy6tgg2kc23yu7id7cenbt6tkm24tloj@nlr47dbh7n65>
References: <000000000000a7d8f1061d69ebd5@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000a7d8f1061d69ebd5@google.com>
X-Migadu-Flow: FLOW_OUT

#syz fix: bcachefs: Fix warning in bch2_fs_journal_stop()
