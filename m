Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D564C136351;
	Fri, 31 Jan 2025 18:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738348373; cv=none; b=A1+23kxoXfjNHYOr+7tIFOEjYyjFUieWYO0kq74kWiHc3/ZEz4x6OEcGYTHnYpXSFlaeX1y+I8Hp61gzk0q7LpS5cb9qWdj8Mc+FaNgs0XZo43DxrWV5E6VW2o9iYgBqWFIwaSkCgMURce9AxfedqRXyT3QpAcoCUYcqg1+qrOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738348373; c=relaxed/simple;
	bh=i2HHovjZeF+EJJUO0r5uqipPpa3h/ET2Wz0A7l1LaRM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XtJ2aTevYWcSNx45sRbZdgZ5B754y/Y2Uhsc8eyEV/mWciVTFlxQCYmz1ZPMG5J/PSn9ZbH38smR/oQ7EjmcTx9TBovzpLLj0MGQyJCN6qx5DC3k8LlYMHOQRjKd69HIeuhGCKGClp7Gf6PbDQYXw+wmFe61n796QCvj5mjnMEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=B1mVZyBt; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="B1mVZyBt"
Date: Fri, 31 Jan 2025 13:32:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738348363;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GaGEK6KrgNfaiTcnPAM8cRQVpy8TyVX44EcOSN21RrE=;
	b=B1mVZyBtwPnmwJnhiaQOCOChrTVkQ+u6f9+5xHT1L+zdTzM7ShECBOYmfBrz/NUmtAeVMj
	4pEThFqNq8l3kxjXRw5z2Dtm8dolNqakQYXWDeZ6LG2MpaI0O+8phaNXLvRBWT3Q55sj7X
	a2BWSWlSJvNGycnY1eXreJQyVUOU3yg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: Jeongjun Park <aha310510@gmail.com>, linux-bcachefs@vger.kernel.org, 
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] bcachefs: fix deadlock in journal_entry_open()
Message-ID: <qbago6vr47oqfielablmjiwnegpdoa42ad3rxz4pyv24julqp7@qoerk4wyvfnk>
References: <20250131124751.172123-1-aha310510@gmail.com>
 <D73FB067-2AC0-4175-AFF1-A9C1365EBBCD@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D73FB067-2AC0-4175-AFF1-A9C1365EBBCD@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sat, Feb 01, 2025 at 02:12:37AM +0800, Alan Huang wrote:
> On Jan 31, 2025, at 20:47, Jeongjun Park <aha310510@gmail.com> wrote:
> > 
> > In the previous commit b3d82c2f2761, code was added to prevent journal sequence
> > overflow. Among them, the code added to journal_entry_open() uses the
> > bch2_fs_fatal_err_on() function to handle errors.
> 
> At least, bch2_journal_halt could invoke bch2_journal_halt_locked.

yep

> Is it possible to release the lock before bch2_fs_fatal_err_on() ? Not familiar with journal code yet.

The control flow makes it awkward, halt_locked() looks like the cleanest
solution.
