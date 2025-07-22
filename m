Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3ACE27A92E
	for <linux-bcachefs@vger.kernel.org>; Tue, 22 Jul 2025 17:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753203700; cv=none; b=QbZlQMwampw0pw6qxEHa0WgZA17D5aErRWHl4Fu6sLbxtmBMbTTiEkwctvfUTNbBhmPj7q44Az0XHIjY280vxRGTJBt1duNCnWpw7xwz29iqTTWKB0Y3zZ+cAYBmnqxKQGbR2VWUKy+ZS4+lv4A9Kxj+TddJtejZ76r0tEH1p6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753203700; c=relaxed/simple;
	bh=vK/01zHaEb7rQXNVgPmV0SjAJ+RqFTCi8Dw4/oQ9KnE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qN2DX4BhQwc6LEJnHqeE07OO8qSpA2r7pWDL7T1cB1URmhr263skOuyOl1D9nrXxK0PsYRLUlw3Ow//oSd78HfcrggoZyHZ0xcAGKfT0QIhQIWdl5bZMdmDEvyNEeRNaMM/BlZvdZB2RTbCnY5QI5QyrKoTrhporRAliSZJ3WzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qSuKYSqN; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qSuKYSqN"
Date: Tue, 22 Jul 2025 13:01:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753203695;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vK/01zHaEb7rQXNVgPmV0SjAJ+RqFTCi8Dw4/oQ9KnE=;
	b=qSuKYSqNf10j5b+cihA/2+klt+XGV1OG2CptgAQsDdGu/Ddu2/NyFRWf+M3IwiSJV81Buq
	sR7FaNAMQ/hNFXku74kMZhEbeVRTd8fTrTtfLIIWU+Uu6PU/hS09mf7Ct1XbzA0MRRhFKw
	Sh6wUJ9YJGTdL1Z30TUBel9IroamtHE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+4e41a25632658c77b441@syzkaller.appspotmail.com>
Cc: bfoster@redhat.com, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] WARNING in bch2_prt_printf
Message-ID: <qdgygvgppw6vqjvyxi56tqfkdakctxzbj6gly33655idvkzzju@yzxuwegnlff3>
References: <00000000000090ebe40618212a25@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000090ebe40618212a25@google.com>
X-Migadu-Flow: FLOW_OUT

#syz fix: bcachefs: journal_entry_btree_keys_to_text() is more careful
