Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF3BBA36
	for <linux-bcachefs@vger.kernel.org>; Sat, 19 Jul 2025 18:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752950568; cv=none; b=DaMaMDDygzXw+JkZoKHqsvvWmTfgrY9erDkpM+xHED8IhRi57WdKWCmr4uTluCRm5i97VdWMrLhRFunSZmaX5jIuUaHwcUkhOs9d4jPA4qJP9a60CxGwvxe+if6k6bE9MR6hYLCxTMZ0/ZssIkPo4tnETYOgRSBXP4p+8PZo0Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752950568; c=relaxed/simple;
	bh=+tLKTgmWoRrvmT4xEkDoOxdZOaWizKtpVw641oljU+w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XSgd6fgj4Cn9/+2NN9PQruUlkpb3PPZWUusxHmp9kcDJo7D8PJfNOSkIOwoDiVGvyoq+B5CFhorZ7l5tM7pp1k/cGMy6/9G2oM/h65HEP/Ztvb5C37H2rKrhwmRggzBDy/fipna8S4x7nW9cyPRvIL6zMC1KfOSKIeNBxv3rcCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=enQbIFGQ; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="enQbIFGQ"
Date: Sat, 19 Jul 2025 14:42:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752950554;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+tLKTgmWoRrvmT4xEkDoOxdZOaWizKtpVw641oljU+w=;
	b=enQbIFGQXEm24p7siKBCimoGFRpZFi/ZJAIbF240w0leKHU5mHTDZHgyPG1KgdFNqwnzjr
	6rGoK4F2gDc5L/grwQiqTSfbAqS8KE/NzFthhkwaBgX5wWIT7N5xrpEu+PFCmDFWYpnSCv
	xXjV+ATB97nLYyHOTLnSISYOJWzP/ZI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+7b5ffa68b7af11821176@syzkaller.appspotmail.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] KASAN: slab-use-after-free Read in
 bch2_str_hash_repair_key
Message-ID: <nsk5nvwh63cjeapu424wqw7kwqrd2f7ugh52dgporratk2fipt@6menl7nk5a6v>
References: <68488453.a70a0220.27c366.0066.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68488453.a70a0220.27c366.0066.GAE@google.com>
X-Migadu-Flow: FLOW_OUT

#syz fix: bcachefs: Fix alloc_req use after free
