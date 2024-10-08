Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B389A1E1A08
	for <linux-bcachefs@vger.kernel.org>; Tue,  8 Oct 2024 17:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728407865; cv=none; b=E1yYXDMqZDEybKU1QxhSR/OKkgSx/p+p5MYVvvpuhqy3SKWuU/mUyaJZ3jfSz8o37Zo3bP0oDNIY2oUmAf5QVv0YUGRCn84+MaPI3zHOFZeoFGptCHX6EH3CLX9pcSkqE1ljykkKIP4Q/W5SFdB+m7g8Pz5Y4ZlKC1yHOW2Kf2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728407865; c=relaxed/simple;
	bh=Ps5cJj07MBxdw2t2Ls0qfwrulW/cQctChxb69XEQadM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=atHiZfpUGXdawZ1dMm2Dzeem/aHfOjzPlC5k7D5fT0tNXzUZ4t4rKdL4P1SpF3M07W/sYvjJF6bydHKeOvit9d5RG0tLVTeZeU++7+6joxEDT111oU6+9Ul9aImUS/qfr70IxDelgBh45/+WIwoyOzln7jiyr3ngysy7Xq0PhME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=k10D60D0; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="k10D60D0"
Date: Tue, 8 Oct 2024 13:17:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728407861;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=k7QSeq9fcGY8+cZKZEYETRsQs5JfTFZ3971RNFbqB6c=;
	b=k10D60D0g/qFiOLyPg6vUp9kt93iYF+OvOX6BihHli3wHkdKGwZjGWWTIE7rbbzwwockFF
	AyEnTPlkyN95iHqlBiXuxZOkZCjzzkbXeWTQ5I/1H7W6dot5CWBhq5hFosuo2i7GBhKRLT
	HDaRoJb/t90HgOteB4JMNvn/Mh1mCVI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Mohammed Anees <pvmohammedanees2003@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+37186860aa7812b331d5@syzkaller.appspotmail.com
Subject: Re: [PATCH resend v3] bcachefs: Fix NULL pointer dereference in
 bch2_opt_to_text
Message-ID: <xgfwrw3g55wjjceznwgji7szahceaq6pojxkp4edurpbyniirh@idt7cobdxxxa>
References: <20241005130229.9290-1-pvmohammedanees2003@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241005130229.9290-1-pvmohammedanees2003@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sat, Oct 05, 2024 at 06:32:29PM GMT, Mohammed Anees wrote:
> This patch adds a bounds check to the bch2_opt_to_text function to prevent
> NULL pointer dereferences when accessing the opt->choices array. This
> ensures that the index used is within valid bounds before dereferencing.
> The new version enhances the readability.
> 
> Reported-and-tested-by: syzbot+37186860aa7812b331d5@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=37186860aa7812b331d5
> Signed-off-by: Mohammed Anees <pvmohammedanees2003@gmail.com>

Sorry for missing this before, applied
