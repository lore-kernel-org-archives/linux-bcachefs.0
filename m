Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8951487CD
	for <linux-bcachefs@vger.kernel.org>; Sun, 23 Jun 2024 21:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719176453; cv=none; b=BEl+T3jH6flBUQUcvwuCv9Yy0kPhjWD74Tvwb5F/CnSD7eknCm3gXJBy3PbAKp55keoH5TqqQALvq0vBDSnz/At4wA+mouwA03NyWkY0/9fk08pDPvUIHvu9mN60gEEQx8jkCdpptHzQObHmrg/Z23Gyk3ItI10OkdHgFtOf3qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719176453; c=relaxed/simple;
	bh=bHNct4+KQwjy3RRwhEMjcaz/VHzBqHxlmodsbXSX1qA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A6+rozmQUqORwxGAZRWV7NPpACnSKEIj5MbklUf4/4nAiq5NACbP/gfdE5tavvj9hoi19UkkzRmhdZSiCbfj+FvCFNNA/HhoMR8U4ZClM8de6qbz++rhcvMRCoi4idAciBRmyCrtWHomgT9/KXAO3wTmLpqHuuRMN6OmfELYo6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=G1MH8wJ3; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="G1MH8wJ3"
X-Envelope-To: syzbot+1e1b380ef8d95b36f789@syzkaller.appspotmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1719176449;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bHNct4+KQwjy3RRwhEMjcaz/VHzBqHxlmodsbXSX1qA=;
	b=G1MH8wJ3rytJAo5AYKxUln1xDvrRKsYbht/axh3LT82C+6ResiPiui2yYUy6ek5iXTSKCe
	YA5Z45CwRQUMW6d6tYZzaGTAppd8OfF+ONunr0tiiCFtR5ngpY+HR/kt8DmAjTwpUpk0Mn
	2cpnz8hUx9gUWIqN8smLYPF+HP135HE=
X-Envelope-To: bfoster@redhat.com
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: syzkaller-bugs@googlegroups.com
Date: Sun, 23 Jun 2024 17:00:44 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+1e1b380ef8d95b36f789@syzkaller.appspotmail.com>
Cc: bfoster@redhat.com, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] INFO: task hung in journal_quiesce
Message-ID: <uqlg3epgbuqqpj56ekadrzyh7cxcgnil5hb3z2qpv2r42cweja@oedbyfgajr42>
References: <000000000000c5e7f60619bb5ccb@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000c5e7f60619bb5ccb@google.com>
X-Migadu-Flow: FLOW_OUT

#syz fix: bcachefs: Add missing bch2_journal_do_writes() call
