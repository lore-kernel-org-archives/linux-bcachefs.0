Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC7065C
	for <linux-bcachefs@vger.kernel.org>; Sun, 23 Jun 2024 21:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719176738; cv=none; b=KDUdeDkh36JbYVPw8zvLdiqbrAf4KgDtqQJ5R/g7vdZu7AOhAiSUyi2bXdlPyXkf9WHhN/dwtt7IDr8UArKCCKf9pt/Bm8YySeAQxrnh+w2AsyF9f27LZC8Q/IlAWqh7J8AHc3plUyxXFLDZU6wtrbiahBN88748K3piPWg9Qeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719176738; c=relaxed/simple;
	bh=Al+291Xyycs/DdCbGs87MJcKI4GoGP8NCQsNKuLFZFI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p/BHrMwUJ4CThp7kk7hsAg8EAJh5MwnET4soPBD6d0vrH+f6lw12NjeTfwKRkVpwaJ0s2oT+wv/B0OINpNPOaUaN3YIMJkPFvmkE0UpU7RPRmdgjhzmynLxhldqztocg9C+mJ/cOgx92z2DMbaLe12S3NlQ6MRRKPR9DRRmGtes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NJlWa/Bz; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NJlWa/Bz"
X-Envelope-To: syzbot+249018ea545364f78d04@syzkaller.appspotmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1719176735;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Al+291Xyycs/DdCbGs87MJcKI4GoGP8NCQsNKuLFZFI=;
	b=NJlWa/BzVsaUvn75phebeNUUycwmMHvi0pxP4tJACVeYfB5JrJebk5rrJzlvZ44QOopQra
	srUUiulj3TIwRkL7Gutds6ShSdkdFzLeGnAeaoQ3BUStJTVbCATZt2OBkA4tbXmEIwhEQc
	YBwZ1f8JaFiljH4UgRdlMxLCcC37G8E=
X-Envelope-To: bfoster@redhat.com
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: syzkaller-bugs@googlegroups.com
Date: Sun, 23 Jun 2024 17:05:31 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+249018ea545364f78d04@syzkaller.appspotmail.com>
Cc: bfoster@redhat.com, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] UBSAN: shift-out-of-bounds in
 bch2_sb_dev_has_data
Message-ID: <xilto7vl6zouisudamqjaza5z3ziyi5idype64nuuewpxq4gds@3aa575tsq7dn>
References: <000000000000ebf2e0061866b102@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000ebf2e0061866b102@google.com>
X-Migadu-Flow: FLOW_OUT

#syz fix: bcachefs: Fix shift overflows in replicas.c
