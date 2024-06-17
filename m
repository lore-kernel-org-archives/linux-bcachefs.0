Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2571758F
	for <linux-bcachefs@vger.kernel.org>; Mon, 17 Jun 2024 14:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718632891; cv=none; b=h7QRQuGGLH/mdtwLmUbc93kRXLb6GYoxo4yNzCcRVjXLBM0S/n79miIMe10TJlmhv4KqvWPdNVb3MMESS077vfGaPKqBxsUgiDDPwVKm7pG56Mh1LE7JJqqCCQz0asPL8kj/3Ij9zJZzPr+u6SwrulgpTMAU8dIUa5u/SVGv2ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718632891; c=relaxed/simple;
	bh=Q1Zurbia1cZXhHJODYajoy72UmkmzSWkLzvC519uJwU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KahPF4XmTpbUR7dLHnL5r14BYnpAXPl08pk07067dQ2GyMDza8AtOwpv/I5mqQjVGASHS5a0hPWv2vuVkCZqKijSVvL5+PyZHQB6ZVmJzB0mZ2S0HTW27Ej5LuKuovscDE8TOlggOmOGcdV/3dm6TKlTtCWu0k0xX2zWDszrXEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sTpJJ5Aq; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sTpJJ5Aq"
X-Envelope-To: syzbot+a7c01586b9012e998c07@syzkaller.appspotmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718632887;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Q1Zurbia1cZXhHJODYajoy72UmkmzSWkLzvC519uJwU=;
	b=sTpJJ5Aqfx2HHH8pk2CkuWs037s6CVNvkWeWmX8mjnlbaRUQfYbW38qK14LEkoeZYxv8FP
	pjQtjrBeLnBerS5W1AOqWL6ORJQm9LSSdTEeDUggoaF1749yKYUAw/tJyRhEfAwcSoMxy0
	0tC5YNPD2AhfYGF3bDNWcW3rT+cPjDU=
X-Envelope-To: bfoster@redhat.com
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: syzkaller-bugs@googlegroups.com
Date: Mon, 17 Jun 2024 10:01:24 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+a7c01586b9012e998c07@syzkaller.appspotmail.com>
Cc: bfoster@redhat.com, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] general protection fault in
 bch2_fs_btree_key_cache_exit
Message-ID: <k5jsfjtel7iscnmt7zuto7tzlysfnreqvp6fmjz6tkipywmkqp@4wvhasubevv4>
References: <0000000000001c53f4061ac0a03c@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000001c53f4061ac0a03c@google.com>
X-Migadu-Flow: FLOW_OUT

#syz fix: bcachefs: Fix early error path in bch2_fs_btree_key_cache_exit()
