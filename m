Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="uqRsedl6";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="LQYhXBSE"
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2a07:de40:b251:101:10:150:64:1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E511712
	for <linux-bcachefs@vger.kernel.org>; Thu,  7 Dec 2023 17:17:03 -0800 (PST)
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6146D220D6;
	Fri,  8 Dec 2023 01:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1701998222; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yWKCVcGtbWhHu2DA1dqn7T4HqFOVG7ZxGxbtuMJDVSU=;
	b=uqRsedl6+LQxVFrQWzjIXXqamOvGk7J5ebk/uV0Ueoic8MEMzSKhRWIKfDak0gugNIC8dR
	aJANHLBTQyFbIjClTX6ULRravHolfIZvo9/rP+1HCscZXXAJDX+iQJNFFouYlfB796IS6K
	3mvOuhOhASx76pgzAyXn2qVgJmThfBA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1701998222;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yWKCVcGtbWhHu2DA1dqn7T4HqFOVG7ZxGxbtuMJDVSU=;
	b=LQYhXBSEsMYkCb5EIj+ARUeyU+QERRqMNMYC8r/T3WSohBg+47a7MslcXNuzgptCEGGvBY
	/SRY+pyeFgkZtIDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B8A0513725;
	Fri,  8 Dec 2023 01:17:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id U874GYxucmXUDQAAD6G6ig
	(envelope-from <neilb@suse.de>); Fri, 08 Dec 2023 01:17:00 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "NeilBrown" <neilb@suse.de>
To: "Donald Buczek" <buczek@molgen.mpg.de>
Cc: "Kent Overstreet" <kent.overstreet@linux.dev>,
 linux-bcachefs@vger.kernel.org, "Stefan Krueger" <stefan.krueger@aei.mpg.de>
Subject: Re: How to cope with subvolumes and snapshots on muti-user systems?
In-reply-to: <97375d00-4bf7-4c4f-96ec-47f4078abb3d@molgen.mpg.de>
References: <3222cf4b-8f9d-4576-b2e2-c78e5655f4dc@molgen.mpg.de>,
 <20231129214328.efbfpl3javifvwk5@moria.home.lan>,
 <63ca9346-6bec-40d5-8f7e-4181721652f1@molgen.mpg.de>,
 <20231130073948.v3jkmmvtwnefwvq3@moria.home.lan>,
 <170137665630.7109.15666373159604652834@noble.neil.brown.name>,
 <3b2720ca-23eb-4666-b04f-5bff4b1ac1cf@molgen.mpg.de>,
 <170172993746.7109.10813288295717935377@noble.neil.brown.name>,
 <12f711f9-70a2-408e-8588-2839e599b668@molgen.mpg.de>,
 <170181366042.7109.5045075782421670339@noble.neil.brown.name>,
 <97375d00-4bf7-4c4f-96ec-47f4078abb3d@molgen.mpg.de>
Date: Fri, 08 Dec 2023 12:16:53 +1100
Message-id: <170199821328.12910.289120389882559143@noble.neil.brown.name>
X-Spamd-Result: default: False [0.90 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 RCPT_COUNT_THREE(0.00)[4];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 SUBJECT_ENDS_QUESTION(1.00)[];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-0.00)[28.28%]
Authentication-Results: smtp-out1.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: 0.90

On Thu, 07 Dec 2023, Donald Buczek wrote:
> 
> I'd vote for the subvol-id.  I think, with bcachefs a u32 would do,
> but it could be return as u64 for future growth or other filesystems.

Probably a good choice.  Though I'd like to re-emphasise that even doing
this doesn't remove the need to make sure inode numbers are as unique as
they can possibly be made.  There are multiple places in /proc (for
example) where a file is identified by fsid and inode number.  It isn't
really practical to insert a volume-id in there (though maybe we could
duplicate all those interfaces....).

Inode numbers would need to be absolutely unique with a volume, and
mostly unique within a filesystem.  xor-ing the internal inode number
with a hash of the volume number is one way to achieve this.

i.e.: while enabling processes that use stat() family function is
clearly import, it does not solve all the problems caused by the
addition of a volume/subvol level between "filesystem" and "inode".

Thanks,
NeilBrown

