Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E741C2E7BAE
	for <linux-bcachefs@vger.kernel.org>; Fri, 18 Jul 2025 19:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752865959; cv=none; b=cp380zlbOU8LLwzVT7+u0G+QUGYjBlJFaKG4CvNjBobBPAZRAlUZYiwpNnVAUFWnBwchnqlztVv2f99XGscnhnU4vvJAXg52jhxFM4//GiL8qyzbQqjIov0fp2AZ9gPNgHWS6rtZzzcoAep8UasFTlMOZBrmUby9jHKZyJrBN5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752865959; c=relaxed/simple;
	bh=bKnN9RrMlAtIOWt48FIcqVDHN3u1j94bB/HjQ6R1QFU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C4OB+A5eKmQuaG0Zdq5j2cgVtVfU98SnQIU9++8ZNw8K3nZzM/oXYMJ5uwhhIFMSAtKOBe3SGC5Zc0Qor7Zz6R+sFBkaX7s70Q6i9/qa2YBYTzwQXg/cGAHQLYwx7WFBbbtX1yAkz3ubTx8Lkss5vjJyMsCdcRNohUcsGprHK7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BLP1CKiL; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BLP1CKiL"
Date: Fri, 18 Jul 2025 15:12:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752865942;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bKnN9RrMlAtIOWt48FIcqVDHN3u1j94bB/HjQ6R1QFU=;
	b=BLP1CKiLJLda/C2n+z8YOT9NtrEaUpb6zao3AxXxnITmaPxnvaPNlHWY8DktTB9JQ0TRUJ
	u7kd41P1I8bhUTQrprzvvDT6RO7y8pFsrCWE8TpOcKHI5T0FLhLSIfs/z2zlLEqv0zxbWR
	gmgdjUa/OuVd1g5xCHjTXwphDnCEhOM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+6d52ee9afea131b36348@syzkaller.appspotmail.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] WARNING in bch2_dev_free (2)
Message-ID: <aqrnbpyywgfg7t4mq5mfzwfgh3lgzsrzc27mlvgenf3swszkdz@2aj37hqzkbp3>
References: <68794b5d.a70a0220.693ce.0051.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68794b5d.a70a0220.693ce.0051.GAE@google.com>
X-Migadu-Flow: FLOW_OUT

Fixed version is now in linux-next...

#syz fix: bcachefs: Fix __bch2_fs_read_write() error path
