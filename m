Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30C02576
	for <linux-bcachefs@vger.kernel.org>; Tue, 22 Jul 2025 03:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753155493; cv=none; b=PA2EjSLrC3fqkf5g+SxR40cBO8c7L5QrAIUe7j4bOzpiDyhlaV4ihjOFhyk8o4+7ukpWwXn7J0OZCvFxErlicrr6qlaDi2MKypmU/0FGWJRE+dQDBTrNFgg8XWaVUZF5N5rFBRX2///6Sf7RTw++FXupz3GT0R13q0Bzg6KIanw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753155493; c=relaxed/simple;
	bh=/QByd6lmAgHfdlrJrctMfYFSZ8M2I3T28B+PfZ+eV6Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ph5bjdSTKb70J+3frZCJ/b7iHUFSagmgTJpadCiKeV0HaOEEU5TzSQVuOu4hHXbx8fCMNzkJd9RwLfnBYVnoz64HiokrlQxZP6L296EegMPL1/GgayNiK1Wf2sN/pdi2Wf4z+yE/YHb78DkQxyD1f+ZDUjhYmRDuOacvLcXRqrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=v5lAizIr; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="v5lAizIr"
Date: Mon, 21 Jul 2025 23:37:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753155479;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/QByd6lmAgHfdlrJrctMfYFSZ8M2I3T28B+PfZ+eV6Q=;
	b=v5lAizIrdZFx3b0Jaz/NrGUTrLr+MNS62SnILt3UztPRSmpM7pa05Da8M88zP3hiLD7X58
	AVLo17HGfV4Tz/0tkznBgMCnzWUXZ/mbOd5W6torhnvqZIG1gnfukAY1IRsANAV6tdS4W8
	Z2m3JlglWAdsoz1thxcBHLiuZiwq9Xg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+8e47e16c9fe5b95a3a88@syzkaller.appspotmail.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] KASAN: slab-use-after-free Write in
 bch2_do_discards
Message-ID: <xjpesph7xntlkzxsuad6gs7rimdaj7yajfzohh2vts7fxexbzz@szbjvp65o32s>
References: <687edfde.a70a0220.61950.0089.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <687edfde.a70a0220.61950.0089.GAE@google.com>
X-Migadu-Flow: FLOW_OUT

#syz fix: bcachefs: Fix UAF by journal write path
