Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A8622313
	for <linux-bcachefs@vger.kernel.org>; Thu,  4 Jul 2024 22:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720130801; cv=none; b=a6v3uOdqlbkjuHufuULoxIdZChRNxBjTYMvERpxU6BELTmchzQ8qo3Q8zpFtiueT/BwOvJSlcm05JbIyFAodXponjODW/DIbzuUSB+qFuQZBbZ0yXtZ3z3GTYvJ4INeJui/8N7JuxHJkLCGau5bvPOXIjGrJJl3C/zB+GGViho0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720130801; c=relaxed/simple;
	bh=UFV+r/FdDgjmW/Bs3itLM9/eqc9N3lhVHlLcntS/llo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kh0GMRTcbTiA1dc8uO+IgzJGeyjfplQ+wnuqzF82Ikrz4C3OWWvjzhnPfpJEBMnxqfyvAvjbh0IAMj2hHpzUa5Gy810LG+VlsS4275e65Y0Iz/zDA36fP81cjLSIxgln/jvubVAl7HSgWaNhEiy/uvE+6YeWHXWX69y2MryhnxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Nya6r4nS; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Nya6r4nS"
X-Envelope-To: syzbot+53a6240f92421be04a12@syzkaller.appspotmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1720130795;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UFV+r/FdDgjmW/Bs3itLM9/eqc9N3lhVHlLcntS/llo=;
	b=Nya6r4nSPZbtpm6o5+Rp9oxBpPpEd9s04HK20+uXNSWMME387WahlQwl9PUeSBPNyDYljR
	TpQM/88OqsHyCAPxMW/nJN9p+Vhu/JXnMez86wG0R/X3xD6WR0sGX/rOkewGDi2shdICQM
	qAqWzTLawBZBgJdM0d9b7N8dFNqiHk0=
X-Envelope-To: bfoster@redhat.com
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: syzkaller-bugs@googlegroups.com
Date: Thu, 4 Jul 2024 18:06:29 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+53a6240f92421be04a12@syzkaller.appspotmail.com>
Cc: bfoster@redhat.com, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] WARNING in __virt_to_phys (4)
Message-ID: <im5rnzylqxb67fe4lnyazqegof5puclvefcnfrtn3bbzo2jk7n@ggzq3hjbtc6z>
References: <0000000000008ccc65061c6927f5@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000008ccc65061c6927f5@google.com>
X-Migadu-Flow: FLOW_OUT

#syz fix: bcachefs: Fix freeing of error pointers
