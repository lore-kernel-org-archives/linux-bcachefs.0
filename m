Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D928154455
	for <linux-bcachefs@vger.kernel.org>; Tue, 11 Jun 2024 23:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718149106; cv=none; b=ZLst1p6oUfXAb9fQIUomEpddMedmlKS7xGs1DVjDDAp+DJU8tRxI0yK/alJE48Go/nIGgpGQfl7REBh23ru65nQ7Fstzk/9rwaFvBczzXr8isATRVgXnzu5ucIoZHI2GLWgVYUhOjRSq+UXClkOtxJo4Svf5DvwTdFdh/o0hb9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718149106; c=relaxed/simple;
	bh=fLIw24HJGh25IvxM+XVgnFm1s7p+2mdeqRmB3vYlN7A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s1sr2y+RkfjoD2LwuVrLbJ2EUj78Q2pZ6ncV40xVpATYcMV4mIVtx+Xm5VJCrZdC7tIVVscohAQiRsScYe1zspoMxEperzUgj1Nyg1+bhSMA1aAwGsboMpllnTw42bLdk8cn/ltNxCN1ijBKadigSuYo+OpiMCJf/7gPjldOvkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=S6fu1IWx; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="S6fu1IWx"
X-Envelope-To: mjguzik@gmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718149103;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KY2/VQG4owvY7Tp0oU+yKzTr3CNrr/ih01w997Fyym8=;
	b=S6fu1IWxdgm9qLsmX6hCQ2Dn/Lg2Ih+LhSmXak8yH4owxrAfBrtuxoRNQGSgU6MOC6NEdl
	oCGdB4cMp3wQZKRZb1cWLPjDiI0uDEcyhmmXlIanVhMkEUwbyHzShCeFgTTNIlLANfvZHD
	CKnwvJ1s9Hvz/+PRVGMyWiy0iygAiSE=
X-Envelope-To: brauner@kernel.org
X-Envelope-To: viro@zeniv.linux.org.uk
X-Envelope-To: jack@suse.cz
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: linux-fsdevel@vger.kernel.org
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: linux-xfs@vger.kernel.org
X-Envelope-To: david@fromorbit.com
Date: Tue, 11 Jun 2024 19:38:18 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-bcachefs@vger.kernel.org, 
	linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v2 4/4] bcachefs: remove now spurious i_state
 initialization
Message-ID: <q3g7lzfznnbsyqfstyniybpsrgzflwwj5eqdnu6pnyi4nmdcyc@l24omqkytmkc>
References: <20240611120626.513952-1-mjguzik@gmail.com>
 <20240611120626.513952-5-mjguzik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240611120626.513952-5-mjguzik@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jun 11, 2024 at 02:06:26PM GMT, Mateusz Guzik wrote:
> inode_init_always started setting the field to 0.
> 
> Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>

Acked-by: Kent Overstreet <kent.overstreet@linux.dev>
