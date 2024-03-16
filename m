Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5535D1BDD5
	for <linux-bcachefs@vger.kernel.org>; Sat, 16 Mar 2024 18:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710612546; cv=none; b=LlZSMurYi2G2+DzikRVusHk/AWLO59mtvHGZ3i46ia0hQguFk39Kg6ZAv+DoCZSaBB33qUMMb0AD3NfOSDzSwgPyETUxBc1VrUeGDIa0vRoEGREkVgavZUCxbDXVs2SPgp+CkTVwpcH+oCziUq75hheVuY1pWITtY8R3BWT6Cfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710612546; c=relaxed/simple;
	bh=1/ESNNcZn9lqQXVtjdfrlEpAbbfGWxkHhvFv1ach0Ms=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mTYUWjAme3P+44WijiMbyu9RD37yzo+7sueGdYX6BCyF5x0dbxCCqjAm3h2d+J4edRZq3hXOMD075LrJG9Oa4l2nQCIKwRXLuGUo2E+PlN5+R5GTi029zl+uXSiG6DHxQtzm7ppmWz3wPmwqPrcarv33PRhfTjUB2hjy2wAaslI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xiAUKDOC; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xiAUKDOC"
Date: Sat, 16 Mar 2024 14:08:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1710612542;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OP/u9RIYyhLWk0iUKrwa9Uzeont9XakLy6gOWokkRwg=;
	b=xiAUKDOCDoh2EcIirmTcK7eZW8IrR0QifKSLR57iHhDlwTZrWiaRPWTXquRcCtvJiI7sI0
	dLDQYcfiq0fmdjv0/alqqZwZqAj/qe60Td68eCg9fOl99tx+AX9hgHnZ1sHq6CplkrjSQi
	SiEnLrfckfp2V/W4VPXY30MMVC9j3eE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: bcachefs: do not run 6.7: upgrade to 6.8 immediately if you have
 a multi device fs
Message-ID: <3u5f32ilzsmepf2vvm6ronrlaj2hfk6b5mtpjy6eqzyw6tit4b@7l7zfvuki75u>
References: <muwlfryvafsskt2l2hgv3szwzjfn7cswmmnoka6zlpz2bxj6lh@ugceww4kv3jr>
 <foqeflqjf7h2rz4ijmqvfawqzinni3asqtofs3kmdmupv4smtk@7j7mmfve6bti>
 <1962788.PYKUYFuaPT@lichtvoll.de>
 <12401121.O9o76ZdvQC@lichtvoll.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <12401121.O9o76ZdvQC@lichtvoll.de>
X-Migadu-Flow: FLOW_OUT

On Sat, Mar 16, 2024 at 06:31:58PM +0100, Martin Steigerwald wrote:
> Martin Steigerwald - 16.03.24, 17:49:52 CET:
> > > > Unfortunately I need to do exactly that, as 6.8.1 breaks hibernation
> > 
> > > > on ThinkPad T14 AMD Gen 1:
> > […]
> > 
> > > run this tree then:
> > > 
> > > https://evilpiepirate.org/git/bcachefs.git/log/?h=bcachefs-for-v6.7
> > 
> > Wonderful. Thanks! Compiling this one instead. Shall I report something
> > to you once I booted into it? I read you had difficulties getting those
> > patches into stable.
> 
> It seems that the downgrade succeeded.
> 
> First mount:
> 
> [   22.565053] bcachefs (dm-5): mounting version 1.4: (unknown version) opts=metadata_checksum=xxhash,data_checksum=xxhash,compression=lz4
> [   22.565686] bcachefs (dm-5): recovering from clean shutdown, journal seq 116996
> [   22.565717] bcachefs (dm-5): Version downgrade required:
> 
> [   22.590487] bcachefs (dm-5): alloc_read... done
> [   22.597896] bcachefs (dm-5): stripes_read... done
> [   22.597930] bcachefs (dm-5): snapshots_read... done
> [   22.651106] bcachefs (dm-5): journal_replay... done
> [   22.651667] bcachefs (dm-5): resume_logged_ops... done
> [   22.651736] bcachefs (dm-5): going read-write
> 
> I wonder whether there was some text supposed to follow
> "Version downgrade required:". The line feed was in the output.
> 
> Second mount:
> 
> [  113.059224] bcachefs (dm-5): mounting version 1.3: rebalance_work opts=metadata_checksum=xxhash,data_checksum=xxhash,compression=lz4
> [  113.059259] bcachefs (dm-5): recovering from clean shutdown, journal seq 117013
> [  113.083911] bcachefs (dm-5): alloc_read... done
> [  113.091268] bcachefs (dm-5): stripes_read... done
> [  113.091281] bcachefs (dm-5): snapshots_read... done
> [  113.142374] bcachefs (dm-5): journal_replay... done
> [  113.142390] bcachefs (dm-5): resume_logged_ops... done
> [  113.142406] bcachefs (dm-5): going read-write

Yup looks good
