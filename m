Received: from bilby.grue.cc (li1738-184.members.linode.com [172.104.158.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13EC43C0A
	for <linux-bcachefs@vger.kernel.org>; Wed, 10 Jan 2024 02:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inml.grue.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inml.grue.cc
Received: from happy-place5.inml.grue.cc ([100.64.10.15] helo=happy-place5.inml.grue.cc)
	by bilby.grue.cc with esmtp (Exim 4.96)
	(envelope-from <lkml@inml.grue.cc>)
	id 1rNO5Y-007gl4-0B;
	Wed, 10 Jan 2024 13:13:04 +1100
Received: from hogarth by bunyip.jovian.space with local (Exim 4.97)
	(envelope-from <lkml@inml.grue.cc>)
	id 1rNO5V-00000000GcM-2onz;
	Wed, 10 Jan 2024 13:13:01 +1100
Date: Wed, 10 Jan 2024 13:13:01 +1100
From: AP <lkml@inml.grue.cc>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: Error while unlocking encrypted BCacheFS: Required key not
 available
Message-ID: <ZZ39La7UjQVwQ1aI@inml.grue.cc>
Mail-Followup-To: AP <lkml@inml.grue.cc>,
	Martin Steigerwald <martin@lichtvoll.de>,
	linux-bcachefs@vger.kernel.org
References: <2312305.ElGaqSPkdT@lichtvoll.de>
 <1876799.tdWV9SEqCh@lichtvoll.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1876799.tdWV9SEqCh@lichtvoll.de>

On Sun, Jan 07, 2024 at 12:27:29PM +0100, Martin Steigerwald wrote:
> In case this is an issue with Debian packaging of bcachefs-tools I can 
> report there.

What version of bcachefs-tools are you using? The default one in bookworm
is v0.24 and is >1 year old and that may be the issue.

I'm starting to switch from btrfs to bcachefs and I backported v1.3.4 from
sid.

AP
